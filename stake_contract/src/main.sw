contract;

dep stakeLib;
dep error;
dep data_structure;

use data_structure::StakeInfo;
use error::Errors;
use stakeLib::StakeAbi;
use std::call_frames::contract_id;
use std::{
    context::balance_of,
    identity::Identity,
    contract_id::ContractId,
    auth::*, 
    token::*,
    logging::log,
    storage::{StorageMap, StorageVec},
    revert::*,
    option::*,
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
        // require(, Errors::InsufficientBalance);

        // get Currect contract Id
        let my_contract_id : ContractId = contract_id();
        // sender should not be staked_before
        let info = Option::Some( storage.stakerInfos.get(address)); // If address already present in storage
        if !info.is_some() { // if address not present in database
            // transfer(From : depositer, to: contractAddress)
            // transfer_to_address(amount, DONUT, my_contract_address); /*transfer should be initialize from the frontend*/
            // add details to stakeContract_Storage
            let info = StakeInfo{
                hashStaked : true,
                hasWithdrawn : false,
                starTs : 0,// what should i use for time **********
                endTs : 0+storage.planDuration,//?????????
                amount : amount,
                claimed : 0,
            };
            storage.stakerInfos.insert(address,info);
            return true;
        } else{ // if address already present
            //but shouldn't staked before
            require(!info.unwrap().hashStaked, Errors::AlreadyInvested);
            // transfer(amount, DONUT, my_contract_id); /*transfer should be initialize from the frontend*/
                // update details to stakeContract_Storage
                let info = StakeInfo{
                    hashStaked : true,
                    hasWithdrawn : false,
                    starTs : 0,// what should i use for time **********
                    endTs : 0+storage.planDuration,//?????????
                    amount : amount,
                    claimed : 0,
                };
                storage.stakerInfos.insert(address,info);
                return true;
        }
        false
    }
    
    // fn is to withdrawn the token
    #[storage(read, write)]
    fn withdraw() -> bool {
        let time = 31;
        // get the sender address first
        let sender = msg_sender().unwrap();
        let address = match sender{
            Identity::Address(addr) => addr,
            _ => revert(404),
        };
        // the msg_sender should participated
        let info = Option::Some(storage.stakerInfos.get(address));
        require(info.is_some(), Errors::NotInvested);
        require(info.unwrap().hashStaked, Errors::NotInvested);

        // msg_sender should not claimed_reward already
        require(!info.unwrap().hasWithdrawn, Errors::RewardClaimedAlready);
        // token should not exceed time limit
        require(time<=storage.planExpired, Errors::TimeLimitExceeded);
        if time>=storage.planDuration{
            let invested_amount = info.unwrap().amount;
            let amount_with_interest = invested_amount + invested_amount*storage.interestRate;
            transfer_to_address(amount_with_interest, DONUT, address);

            // update details to stakeContract_Storage
            let info = StakeInfo{
                hashStaked : false,
                hasWithdrawn : true,
                starTs : 0,// what should i use for time **********
                endTs : 0,//?????????
                amount : 0,
                claimed : amount_with_interest,
            };
            storage.stakerInfos.insert(address,info);
            return true;
        }
        return false;
    }

    #[storage(read,write)]
    fn unstake()-> bool{
        let time = 30;
        // get the sender address first
        let sender = msg_sender().unwrap();
        let address = match sender{
            Identity::Address(addr) => addr,
            _ => revert(404),
        };
        // the msg_sender should participated
        let info = Option::Some(storage.stakerInfos.get(address));
        require(info.is_some(), Errors::NotInvested);
        require(info.unwrap().hashStaked, Errors::NotInvested);

        // msg_sender should not claimed_reward already
        require(!info.unwrap().hasWithdrawn, Errors::RewardClaimedAlready);

        // token should not exceed time limit
        require(time <= storage.planExpired, Errors::TimeLimitExceeded);

        // get the invested_amount of the caller
        let invested_amount :u64 =  info.unwrap().amount;

        // return the actual amount caller invested
        transfer_to_address(invested_amount, DONUT, address);

        // update details to stakeContract_Storage
        let info = StakeInfo{
            hashStaked : false,
            hasWithdrawn : true,
            starTs : 0,// what should i use for time **********
            endTs : 0,//?????????
            amount : 0,
            claimed : 0,
        };
        storage.stakerInfos.insert(address,info);

        true
    }
}
