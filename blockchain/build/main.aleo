program blockchain.aleo;

record DatasetCommitment:
    owner as address.private;
    dataset_id as field.private;
    row_count as u64.private;
    column_count as u32.private;
    timestamp as u32.private;

record ColumnStats:
    owner as address.private;
    dataset_id as field.private;
    column_index as u32.private;
    min_value as u64.private;
    max_value as u64.private;
    is_categorical as boolean.private;

record SyntheticProof:
    owner as address.private;
    source_dataset_id as field.private;
    synthetic_sample_count as u64.private;
    generation_method_hash as field.private;
    verified as boolean.private;
    timestamp as u32.private;

mapping datasets:
    key as field.public;
    value as u64.public;

mapping proofs:
    key as field.public;
    value as boolean.public;

function register_dataset:
    input r0 as field.private;
    input r1 as u64.private;
    input r2 as u32.private;
    input r3 as u32.private;
    cast self.caller r0 r1 r2 r3 into r4 as DatasetCommitment.record;
    async register_dataset r0 r1 into r5;
    output r4 as DatasetCommitment.record;
    output r5 as blockchain.aleo/register_dataset.future;

finalize register_dataset:
    input r0 as field.public;
    input r1 as u64.public;
    set r1 into datasets[r0];

function register_column_stats:
    input r0 as field.private;
    input r1 as u32.private;
    input r2 as u64.private;
    input r3 as u64.private;
    input r4 as boolean.private;
    lte r2 r3 into r5;
    assert.eq r5 true;
    cast self.caller r0 r1 r2 r3 r4 into r6 as ColumnStats.record;
    output r6 as ColumnStats.record;

function generate_synthetic_value:
    input r0 as ColumnStats.record;
    input r1 as u64.private;
    gte r0.max_value r0.min_value into r2;
    assert.eq r2 true;
    sub r0.max_value r0.min_value into r3;
    is.eq r3 0u64 into r4;
    add r3 1u64 into r5;
    rem r1 r5 into r6;
    add r0.min_value r6 into r7;
    ternary r4 r0.min_value r7 into r8;
    output r8 as u64.private;

function verify_synthetic_value:
    input r0 as ColumnStats.record;
    input r1 as u64.private;
    gte r1 r0.min_value into r2;
    lte r1 r0.max_value into r3;
    and r2 r3 into r4;
    output r4 as boolean.private;

function verify_synthetic_batch:
    input r0 as ColumnStats.record;
    input r1 as u64.private;
    input r2 as u64.private;
    input r3 as u64.private;
    input r4 as u64.private;
    input r5 as u64.private;
    gte r1 r0.min_value into r6;
    lte r1 r0.max_value into r7;
    and r6 r7 into r8;
    gte r2 r0.min_value into r9;
    lte r2 r0.max_value into r10;
    and r9 r10 into r11;
    gte r3 r0.min_value into r12;
    lte r3 r0.max_value into r13;
    and r12 r13 into r14;
    gte r4 r0.min_value into r15;
    lte r4 r0.max_value into r16;
    and r15 r16 into r17;
    gte r5 r0.min_value into r18;
    lte r5 r0.max_value into r19;
    and r18 r19 into r20;
    and r8 r11 into r21;
    and r21 r14 into r22;
    and r22 r17 into r23;
    and r23 r20 into r24;
    output r24 as boolean.private;

function issue_synthetic_proof:
    input r0 as DatasetCommitment.record;
    input r1 as u64.private;
    input r2 as field.private;
    input r3 as u32.private;
    assert.eq self.caller r0.owner;
    gt r1 0u64 into r4;
    assert.eq r4 true;
    lte r1 1000000u64 into r5;
    assert.eq r5 true;
    hash.bhp256 r2 into r6 as field;
    cast self.caller r0.dataset_id r1 r2 true r3 into r7 as SyntheticProof.record;
    async issue_synthetic_proof r6 into r8;
    output r7 as SyntheticProof.record;
    output r8 as blockchain.aleo/issue_synthetic_proof.future;

finalize issue_synthetic_proof:
    input r0 as field.public;
    set true into proofs[r0];

function verify_privacy_budget:
    input r0 as u64.private;
    input r1 as u64.private;
    input r2 as u32.private;
    mul r1 100u64 into r3;
    div r3 r0 into r4;
    gte r4 20u64 into r5;
    lte r4 200u64 into r6;
    and r5 r6 into r7;
    gte r2 1u32 into r8;
    lte r2 1000u32 into r9;
    and r8 r9 into r10;
    and r7 r10 into r11;
    output r11 as boolean.private;

function transfer_dataset:
    input r0 as DatasetCommitment.record;
    input r1 as address.private;
    assert.eq self.caller r0.owner;
    cast r1 r0.dataset_id r0.row_count r0.column_count r0.timestamp into r2 as DatasetCommitment.record;
    output r2 as DatasetCommitment.record;

function verify_correlation:
    input r0 as u64.private;
    input r1 as u64.private;
    input r2 as u32.private;
    input r3 as u32.private;
    is.eq r0 0u64 into r4;
    mul r1 100u64 into r5;
    div r5 r0 into r6;
    cast r2 into r7 as u64;
    gte r6 r7 into r8;
    cast r3 into r9 as u64;
    lte r6 r9 into r10;
    and r8 r10 into r11;
    ternary r4 false r11 into r12;
    output r12 as boolean.private;

constructor:
    assert.eq edition 0u16;
