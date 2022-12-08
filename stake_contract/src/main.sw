contract;

dep stakeLib;
dep error;

use error::Error;
use stake_contract_lib::stakeAbi;
use std::{address::Address, identity::Identity};
use std::storage::StorageMap;
storage{
    planDuration :u8 = 30,
    interestRate :u8 = 10,
    planExpired :u8 = 90,

    stakingBalance : StorageMap<Address, u64> = StorageMap{},
    hasStaked : StorageMap<Address, bool> = StorageMap{},
    hasWithdrawn : StorageMap<Address, bool> = StorageMap{},
    stakeInfos : storageM<Stakeinfo> = StorageMap{},
}
struct StakeInfo{
        starTs : u128,
        endTs : u128,
        amount : u128,
        claimed : u128,
    }

// const Donut = 0xa6a3a923be200e7ace6dac39cc555f636636b27472017e54cd520c5e42f07546;

impl stakeAbi for Contract {
    #[storage(read, write)]
    fn deposite_token(address : Address, amount : u64){
        // amount should be greater that Zero
        // require(amount > 0, "Error::InvalidAmount");

        // Sender should have balance >= amount
        // require(balance_of(msg_sender()))

        // sender should not be staked_before
        // transfer_from()
    }
    #[storage(read, write)]
    fn withdraw(address : Address) -> bool {
        // the msg_sender should participated

        // msg_sender should not claimed_reward already

        // token should not exceed time limit
        
        // if stake time not met return zero

    }
}
