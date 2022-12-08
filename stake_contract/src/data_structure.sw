library data_structure;

pub struct StakeInfo{
        address : Address,
        hashStaked : bool,
        hasWithdrawn : bool,
        starTs : u64,
        endTs : u64,
        amount : u64,
        claimed : u64,
    }