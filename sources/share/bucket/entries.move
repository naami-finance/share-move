module naami::bucket_entries {
    use naami::bucket::ShareBucket;
    use sui::tx_context::TxContext;
    use naami::bucket;
    use sui::transfer;
    use sui::tx_context;

    public fun split<T>(bucket: ShareBucket<T>, amount: u64, ctx: &mut TxContext) {
        let (b1, b2) = bucket::split(bucket, amount, ctx);
        transfer::transfer(b1, tx_context::sender(ctx));
        transfer::transfer(b2, tx_context::sender(ctx));
    }

    public fun merge<T>(left: ShareBucket<T>, right: ShareBucket<T>, ctx: &mut TxContext) {
        transfer::transfer(
            bucket::merge(left, right, ctx),
            tx_context::sender(ctx)
        );
    }
}