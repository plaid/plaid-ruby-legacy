## Upgrading from 2.x.x to 3.0.0

Version 3.0.0 makes `PlaidHack::Institution` use new `institutions/all` endpoint
of PlaidHack API which unites "native" and "long tail" institutions.
`PlaidHack::LongTailInstitution` class is removed, its functionality is
concentrated in `PlaidHack::Institution`.

Use `PlaidHack::Institution.all` instead of `PlaidHack::LongTailInstitution.all` (the
semantics is the same, with added products param).

Use `PlaidHack::Institution.search` instead of `PlaidHack::LongTailInstitution.search`.

Use `PlaidHack::Institution.search_by_id` instead of `PlaidHack::LongTailInstitution.get`.


## Upgrading from 1.x to 2.0.0

Make sure you use Ruby 2.0 or higher.

Update the `PlaidHack.config` block:

```ruby
PlaidHack.config do |p|
  p.client_id = '<<< PlaidHack provided client ID >>>'  # WAS: customer_id
  p.secret = '<<< PlaidHack provided secret key >>>'    # No change
  p.env = :tartan  # or :api for production         # WAS: environment_location
end
```

Use `PlaidHack::User.create` instead of `PlaidHack.add_user` (**NOTE**: parameter order has changed!)

Use `PlaidHack::User.load` instead of `PlaidHack.set_user` (**NOTE**: parameter order has changed!)

Use `PlaidHack::User.exchange_token` instead of `PlaidHack.exchange_token` (**NOTE**: parameter list has changed!)

Use `PlaidHack::User.create` or (`.load`) and `PlaidHack::User#transactions` instead of `PlaidHack.transactions`.

Use `PlaidHack::Institution.all` and `PlaidHack::Institution.get` instead of `PlaidHack.institution`.

Use `PlaidHack::Category.all` and `PlaidHack::Category.get` instead of `PlaidHack.category`.

`PlaidHack::Account#institution_type` was renamed to `PlaidHack::Account#institution`.

`PlaidHack::Transaction#account` was renamed to `PlaidHack::Transaction#account_id`.

`PlaidHack::Transaction#date` is a Date, not a String object now.

`PlaidHack::Transaction#cat` was removed. Use `PlaidHack::Transaction#category_hierarchy` and `PlaidHack::Transaction#category_id` directly.

`PlaidHack::Transaction#category` was renamed to `PlaidHack::Transaction#category_hierarchy`.

`PlaidHack::Transaction#pending_transaction` was renamed to `PlaidHack::Transaction#pending_transaction_id`.

Use `PlaidHack::User#mfa_step` instead of `PlaidHack::User#select_mfa_method` and `PlaidHack::User#mfa_authentication`.

`PlaidHack::User#permit?` was removed. You don't need this.

`PlaidHack::User.delete_user` was renamed to `PlaidHack::User.delete`.

**NOTE** that Symbols are now consistently used instead of Strings as product names, keys in hashes, etc. Look at the docs, they have all the examples.
