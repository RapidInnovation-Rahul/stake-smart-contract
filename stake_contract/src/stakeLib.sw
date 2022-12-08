library stakeLib;

abi stakeAbi{
    
    // this fn is to take token
    #[storage(read, write)]
    fn deposite_token(address : Address, amount : u64)-> bool;

    // this fn is to calculate the interest
    #[storage(read, write)]
    fn withdraw(amount : u64) -> bool;
}
