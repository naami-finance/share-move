module shares::bucket {
    use sui::object::{UID, ID};
    use sui::tx_context::TxContext;
    use sui::object;
    use sui::tx_context;

    friend shares::registry;

    struct ShareBucket<phantom T> has key, store {
        id: UID,
        shares: u64,
        last_modification: u64
    }

    public(friend) fun create<T>(shares: u64, ctx: &mut TxContext): ShareBucket<T> {
        ShareBucket {
            id: object::new(ctx),
            shares,
            last_modification: tx_context::epoch(ctx)
        }
    }

    public fun id<T>(bucket: &ShareBucket<T>): &ID {
        object::uid_as_inner(&bucket.id)
    }

    public fun uid<T>(bucket: &ShareBucket<T>): &UID {
        &bucket.id
    }

    public fun last_modification<T>(bucket: &ShareBucket<T>): u64 {
        bucket.last_modification
    }

    public fun shares<T>(bucket: &ShareBucket<T>): u64 {
        bucket.shares
    }

    public fun split<T>(bucket: ShareBucket<T>, amount: u64, ctx: &mut TxContext): (ShareBucket<T>, ShareBucket<T>) {
        let ShareBucket { id, shares, last_modification: _ } = bucket;

        assert!(shares > amount, 0);

        let (left, right) = (shares - amount, amount);

        object::delete(id);

        (
            create(left, ctx),
            create(right, ctx)
        )
    }

    public fun merge<T> (left: ShareBucket<T>, right: ShareBucket<T>, ctx: &mut TxContext): ShareBucket<T> {
        let ShareBucket { id: right_id, shares: right_shares, last_modification: _right_modification } = right;
        let ShareBucket { id: left_id, shares: left_shares, last_modification: _left_modification } = left;

        object::delete(left_id);
        object::delete(right_id);

        create(left_shares + right_shares, ctx)
    }
}
