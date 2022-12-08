library stakeLib;

abi StakeAbi {
    
    // this fn is to take token
    #[storage(read, write)]
    fn deposite_token(amount: u64) -> bool;

    // this fn is to calculate the interest
    #[storage(read, write)]
    fn withdraw() -> bool;
}
