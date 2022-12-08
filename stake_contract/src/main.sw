contract;

dep stakeLib;
dep error;
dep data_structure;

use data_structure::StakeInfo;
use error::Errors;
use stakeLib::StakeAbi;
use std::{
    call_frames::contract_id,
    context::balance_of,
    identity::Identity,
    contract_id::ContractId,
    auth::*, 
    logging::log,
    storage::{StorageMap, StorageVec},
    revert::*
};

storage {
    planDuration :u8 = 30,//days
    interestRate :u8 = 10,//percent
    planExpired :u8 = 90,//days
    
    stakerInfos: StorageMap<Address, StakeInfo> = StorageMap{},
    // hasStaked : StorageMap<Address, bool> = StorageMap{},
    // hasWithdrawn : StorageMap<Address, bool> = StorageMap{},
    // stakeInfos : StorageVec<Stakeinfo> = StorageVec{},
}

const DONUT = ContractId::from(0xa6a3a923be200e7ace6dac39cc555f636636b27472017e54cd520c5e42f07546);

impl StakeAbi for Contract {

    // fn is to deposite the tokens
    #[storage(read, write)]
    fn deposite_token(amount : u64) -> bool{
        // amount should be greater that Zero
        require(amount > 0, Errors::InvalidAmount);

        // first get the msg_sender address
        let sender = msg_sender().unwrap();
        let address = match sender{
            Identity::Address(addr) => addr,
            _ => revert(404),
        };
        
        // Sender should have balance >= amount
        // require(balance_of(address,msg_asset_id())< amount, Errors::InsufficientBalance);

        // sender should not be staked_before
        let info = storage.stakerInfos.get(address);
        if info == None { // if address not present in database
            // transferFrom(From : depositer, to: contractAddress , amount)

            // add details to stakeContract_Storage
            let info = StakeInfo{
                hashStaked : true,
                hasWithdrawn : false,
                starTs : 0,// what should i use for time **********
                endTs : 0,//?????????
                amount : amount,
                claimed : 0,
            };
            storage.stakerInfos.insert(address,info);
            return true;
        } else{ // if address already present
            //but shouldn't staked before
            require(!info.hashStaked, Error::AlreadyInvested);
                // update details to stakeContract_Storage
                let info = StakeInfo{
                    hashStaked : true,
                    hasWithdrawn : false,
                    starTs : 0,// what should i use for time **********
                    endTs : 0,//?????????
                    amount : amount,
                    claimed : 0,
                };
                storage.stakeInfos.insert(address,info);
                return true;
        }
        false
    }
    
    // fn is to withdrawn the token
    #[storage(read, write)]
    fn withdraw() -> bool {
        // get the sender address first
        let sender = msg_sender().unwrap();
        let address = match sender{
            Identity::Address(addr) => addr,
            _ => revert(404),
        };
        // the msg_sender should participated
        let info = storage.stakerInfos.get(address);
        require(info.is_some(), Error::NotInvested);
        require(info.hashStaked, Error::NotInvested);

        // msg_sender should not claimed_reward already
        require(!info.claimed, Error::RewardClaimedAlready);
        // token should not exceed time limit
        require(,Error::TimeLimitExceeded);
        // if stake time not met return with zero interest
        //if (time >= 30){
            // let invested_amount = info.amount;
            // let amount_with_interest = invested_amount + invested_amount*interestRate;
            // transferFrom(From stakeContract,to: address, amount_with_interest);
        // }
        
        return true;
    }
}
