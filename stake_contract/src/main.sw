contract;

dep stakeLib;
dep error;
dep data_structure;

use data_structure::StakeInfo;
use error::Errors::*;
use stakeLib::StakeAbi;
use std::{identity::Identity};
use std::{auth::msg_sender, logging::log};
use std::storage::*;
use std::revert::*;
storage {
    planDuration :u8 = 30,//days
    interestRate :u8 = 10,//percent
    planExpired :u8 = 90,//days
    contractAddress : Address = contract_id(),//this contract address
    stakerInfos: StorageMap<Address, StakeInfo> = StorageMap{},
    // hasStaked : StorageMap<Address, bool> = StorageMap{},
    // hasWithdrawn : StorageMap<Address, bool> = StorageMap{},
    // stakeInfos : StorageVec<Stakeinfo> = StorageVec{},
    
}

const Donut = ContractId::from(0xa6a3a923be200e7ace6dac39cc555f636636b27472017e54cd520c5e42f07546);

impl StakeAbi for Contract {
    #[storage(read, write)]
    fn deposite_token(amount : u64) -> bool{
        // first get the msg_sender address
        let sender = msg_sender().unwrap();
        let address = match sender{
            Identity::Address(addr) => addr,
            _ => revert(404),
        };
        
        // amount should be greater that Zero
        require(amount > 0, "Errors::InvalidAmount");

        // Sender should have balance >= amount
        require(balance_of(address,Donut)<amount, "Errors::InsufficientBalance");

        // sender should not be staked_before
        let info = storage.stakerInfos.get(address);
        if !info.hashStaked{

            // transferFrom(From : depositer, to: contractAddress , amount)

            // add details to stakeContract_Storage
            let info = StakeInfo{
                address : address,
                hashStaked : true,
                hasWithdrawn : false,
                starTs : 0,// what should i use for time **********
                endTs : 0,//?????????
                amount : amount,
                claimed : 0,
            };
            return false;
        };
        true
    }
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
        if info.hashStaked{
            // msg_sender should not claimed_reward already
            
            // token should not exceed time limit
            
            // if stake time not met return zero
            
        };
        return true;
    }
}
