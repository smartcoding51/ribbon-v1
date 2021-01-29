// THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.

import {
  TypedMap,
  Entity,
  Value,
  ValueKind,
  store,
  Address,
  Bytes,
  BigInt,
  BigDecimal
} from "@graphprotocol/graph-ts";

export class InstrumentPosition extends Entity {
  constructor(id: string) {
    super();
    this.set("id", Value.fromString(id));
  }

  save(): void {
    let id = this.get("id");
    assert(id !== null, "Cannot save InstrumentPosition entity without an ID");
    assert(
      id.kind == ValueKind.STRING,
      "Cannot save InstrumentPosition entity with non-string ID. " +
        'Considering using .toHex() to convert the "id" to a string.'
    );
    store.set("InstrumentPosition", id.toString(), this);
  }

  static load(id: string): InstrumentPosition | null {
    return store.get("InstrumentPosition", id) as InstrumentPosition | null;
  }

  get id(): string {
    let value = this.get("id");
    return value.toString();
  }

  set id(value: string) {
    this.set("id", Value.fromString(value));
  }

  get positionID(): i32 {
    let value = this.get("positionID");
    return value.toI32();
  }

  set positionID(value: i32) {
    this.set("positionID", Value.fromI32(value));
  }

  get account(): Bytes | null {
    let value = this.get("account");
    if (value === null || value.kind == ValueKind.NULL) {
      return null;
    } else {
      return value.toBytes();
    }
  }

  set account(value: Bytes | null) {
    if (value === null) {
      this.unset("account");
    } else {
      this.set("account", Value.fromBytes(value as Bytes));
    }
  }

  get cost(): BigInt | null {
    let value = this.get("cost");
    if (value === null || value.kind == ValueKind.NULL) {
      return null;
    } else {
      return value.toBigInt();
    }
  }

  set cost(value: BigInt | null) {
    if (value === null) {
      this.unset("cost");
    } else {
      this.set("cost", Value.fromBigInt(value as BigInt));
    }
  }
}

export class OptionPurchase extends Entity {
  constructor(id: string) {
    super();
    this.set("id", Value.fromString(id));
  }

  save(): void {
    let id = this.get("id");
    assert(id !== null, "Cannot save OptionPurchase entity without an ID");
    assert(
      id.kind == ValueKind.STRING,
      "Cannot save OptionPurchase entity with non-string ID. " +
        'Considering using .toHex() to convert the "id" to a string.'
    );
    store.set("OptionPurchase", id.toString(), this);
  }

  static load(id: string): OptionPurchase | null {
    return store.get("OptionPurchase", id) as OptionPurchase | null;
  }

  get id(): string {
    let value = this.get("id");
    return value.toString();
  }

  set id(value: string) {
    this.set("id", Value.fromString(value));
  }

  get instrumentPosition(): string {
    let value = this.get("instrumentPosition");
    return value.toString();
  }

  set instrumentPosition(value: string) {
    this.set("instrumentPosition", Value.fromString(value));
  }

  get account(): Bytes {
    let value = this.get("account");
    return value.toBytes();
  }

  set account(value: Bytes) {
    this.set("account", Value.fromBytes(value));
  }

  get underlying(): Bytes {
    let value = this.get("underlying");
    return value.toBytes();
  }

  set underlying(value: Bytes) {
    this.set("underlying", Value.fromBytes(value));
  }

  get optionType(): i32 {
    let value = this.get("optionType");
    return value.toI32();
  }

  set optionType(value: i32) {
    this.set("optionType", Value.fromI32(value));
  }

  get amount(): BigInt {
    let value = this.get("amount");
    return value.toBigInt();
  }

  set amount(value: BigInt) {
    this.set("amount", Value.fromBigInt(value));
  }

  get premium(): BigInt {
    let value = this.get("premium");
    return value.toBigInt();
  }

  set premium(value: BigInt) {
    this.set("premium", Value.fromBigInt(value));
  }

  get optionID(): i32 {
    let value = this.get("optionID");
    return value.toI32();
  }

  set optionID(value: i32) {
    this.set("optionID", Value.fromI32(value));
  }
}
