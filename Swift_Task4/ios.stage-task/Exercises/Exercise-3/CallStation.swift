import Foundation

final class CallStation {
    var usersList: [User] = []
    var callsList: [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        return usersList
    }
    
    func add(user: User) {
        
        if usersList.contains(user) == false {
            usersList.append(user)
        }

    }
    
    func remove(user: User) {
        
        if let indexOfUser = usersList.firstIndex(of: user) {
            usersList.remove(at: indexOfUser)
        }
        
    }
    
    func execute(action: CallAction) -> CallID? {
        
        switch action {
        
        case .start(from: let sender, to: let receiver):
            if usersList.contains(sender) == false && usersList.contains(receiver) == false {
                return nil
            } else if usersList.contains(receiver) == false {
                let call = Call(id: UUID.init(), incomingUser: sender, outgoingUser: receiver, status: .ended(reason: .error))
                callsList.append(call)
                return call.id
            }
            
            if currentCall(user: receiver) != nil {
                let call = Call(id: UUID.init(), incomingUser: sender, outgoingUser: receiver, status: .ended(reason: .userBusy))
                callsList.append(call)
            } else {
                let call = Call(id: UUID.init(), incomingUser: sender, outgoingUser: receiver, status: .calling)
                callsList.append(call)
            }
            
            if let index = callsList.firstIndex(where: { $0.incomingUser == sender && $0.outgoingUser == receiver }) {
                return callsList[index].id
            }
            
            return nil
            
        case .answer(from: let receivingUser):
            if let index = calls().firstIndex(where: { $0.outgoingUser == receivingUser }) {
                let call = callsList[index]
                if usersList.contains(receivingUser) == false {
                    let errorCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: receivingUser, status: .ended(reason: .error))
                    callsList[index] = errorCall
                    return nil
                } else {
                    let updatedCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: receivingUser, status: .talk)
                    callsList[index] = updatedCall
                    return updatedCall.id
                }
                
            } else {
                return nil
            }
            
        case .end(from: let endingUser):
            if let index = calls().firstIndex(where: { $0.outgoingUser == endingUser || $0.incomingUser == endingUser }) {
                let call = callsList[index]
                var endUpReason: CallEndReason = .error
                
                if call.status == .calling {
                    endUpReason = .cancel
                } else if call.status == .talk {
                    endUpReason = .end
                } else if currentCall(user: call.outgoingUser)?.status == .ended(reason: .userBusy) {
                    endUpReason = .userBusy
                }
                
                let updatedCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: endUpReason))
                callsList[index] = updatedCall
                return updatedCall.id
            } else {
                return nil
            }
            
        default:
            return nil
        }
    }
    
    func calls() -> [Call] {
        return callsList
    }
    
    func calls(user: User) -> [Call] {
        let callsOfUser = callsList.filter{ $0.incomingUser == user || $0.outgoingUser == user }
        return callsOfUser
    }
    
    func call(id: CallID) -> Call? {
        let call = callsList.first(where: { $0.id == id })
        return call
    }
    
    func currentCall(user: User) -> Call? {
        let call = callsList.first(where: { ($0.incomingUser == user || $0.outgoingUser == user) && ($0.status == .calling || $0.status == .talk) })
        return call
    }
}
