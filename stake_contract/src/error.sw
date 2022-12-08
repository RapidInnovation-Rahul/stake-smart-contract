library error;

pub enum Errors {
    InvalidAmount: (),
    InsufficientBalance: (),
    TimeLimitExceeded: (),
    RewardClaimedAlready: (),
    AlreadyInvested: (),
    NotInvested: (),
}
