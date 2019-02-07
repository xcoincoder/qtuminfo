CREATE TABLE `address` (
  `_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('pubkeyhash','scripthash','witness_v0_keyhash','witness_v0_scripthash','contract','evm_contract','x86_contract') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `data` varbinary(32) NOT NULL,
  `string` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `create_height` int(10) unsigned NOT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE KEY `address` (`data`,`type`),
  UNIQUE KEY `string` (`string`),
  KEY `create_height` (`create_height`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `balance_change` (
  `transaction_id` bigint(20) unsigned NOT NULL,
  `block_height` int(10) unsigned NOT NULL,
  `index_in_block` int(10) unsigned NOT NULL,
  `address_id` bigint(20) unsigned NOT NULL,
  `value` bigint(20) NOT NULL,
  PRIMARY KEY (`transaction_id`,`address_id`),
  UNIQUE KEY `address` (`address_id`,`block_height`,`index_in_block`,`transaction_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `block` (
  `hash` binary(32) NOT NULL,
  `height` int(10) unsigned NOT NULL,
  `size` int(10) unsigned NOT NULL,
  `weight` int(10) unsigned NOT NULL,
  `miner_id` bigint(20) unsigned NOT NULL,
  `transactions_count` int(10) unsigned NOT NULL,
  `contract_transactions_count` int(10) unsigned NOT NULL,
  PRIMARY KEY (`height`),
  UNIQUE KEY `hash` (`hash`),
  KEY `miner` (`miner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `contract` (
  `address` binary(20) NOT NULL,
  `address_string` char(40) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `vm` enum('evm','x86') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` enum('dgp','qrc20','qrc721') CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_id` bigint(20) unsigned NOT NULL,
  `create_transaction_id` varbinary(32) DEFAULT NULL,
  `create_height` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`address`),
  UNIQUE KEY `address` (`address_string`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `contract_code` (
  `contract_address` binary(20) NOT NULL,
  `code` mediumblob NOT NULL,
  `source` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`contract_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `contract_spend` (
  `source_id` binary(32) NOT NULL,
  `dest_id` binary(32) NOT NULL,
  PRIMARY KEY (`source_id`),
  KEY `dest` (`dest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `contract_tag` (
  `_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `contract_address` binary(20) NOT NULL,
  `tag` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`_id`),
  KEY `contract` (`contract_address`),
  KEY `tag` (`tag`)
) ENGINE=InnoDB AUTO_INCREMENT=246 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `gas_refund` (
  `transaction_id` binary(32) NOT NULL,
  `output_index` int(10) unsigned NOT NULL,
  `refund_transaction_id` binary(32) NOT NULL,
  `refund_index` int(10) unsigned NOT NULL,
  PRIMARY KEY (`transaction_id`,`output_index`),
  UNIQUE KEY `refund` (`refund_transaction_id`,`refund_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `header` (
  `hash` binary(32) NOT NULL,
  `height` int(10) unsigned NOT NULL,
  `version` int(11) NOT NULL,
  `prev_hash` binary(32) NOT NULL,
  `merkle_root` binary(32) NOT NULL,
  `timestamp` int(10) unsigned NOT NULL,
  `bits` int(10) unsigned NOT NULL,
  `nonce` int(10) unsigned NOT NULL,
  `hash_state_root` binary(32) NOT NULL,
  `hash_utxo_root` binary(32) NOT NULL,
  `stake_prev_transaction_id` binary(32) NOT NULL,
  `stake_output_index` int(10) unsigned NOT NULL,
  `signature` blob NOT NULL,
  `chainwork` binary(32) NOT NULL,
  PRIMARY KEY (`height`),
  UNIQUE KEY `hash` (`hash`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `qrc20` (
  `contract_address` binary(20) NOT NULL,
  `name` blob NOT NULL,
  `symbol` blob NOT NULL,
  `decimals` tinyint(3) unsigned NOT NULL,
  `total_supply` binary(32) NOT NULL,
  `version` blob,
  PRIMARY KEY (`contract_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `qrc20_balance` (
  `contract_address` binary(20) NOT NULL,
  `address` binary(20) NOT NULL,
  `balance` binary(32) NOT NULL,
  PRIMARY KEY (`contract_address`,`address`),
  KEY `rich_list` (`contract_address`,`balance` DESC),
  KEY `address` (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `qrc721` (
  `contract_address` binary(20) NOT NULL,
  `name` blob NOT NULL,
  `symbol` blob NOT NULL,
  `total_supply` binary(32) NOT NULL,
  PRIMARY KEY (`contract_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `qrc721_token` (
  `contract_address` binary(20) NOT NULL,
  `token_id` binary(32) NOT NULL,
  `holder` binary(20) NOT NULL,
  PRIMARY KEY (`contract_address`,`token_id`),
  KEY `owner` (`holder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `receipt` (
  `_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` bigint(20) unsigned NOT NULL,
  `block_height` int(10) unsigned NOT NULL,
  `index_in_block` int(10) unsigned NOT NULL,
  `output_index` int(10) unsigned NOT NULL,
  `gas_used` int(10) unsigned NOT NULL,
  `contract_address` binary(20) NOT NULL,
  `excepted` enum('None','Unknown','BadRLP','InvalidFormat','OutOfGasIntrinsic','InvalidSignature','InvalidNonce','NotEnoughCash','OutOfGasBase','BlockGasLimitReached','BadInstruction','BadJumpDestination','OutOfGas','OutOfStack','StackUnderflow','CreateWithValue','NoInformation') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE KEY `output` (`transaction_id`,`output_index`),
  KEY `contract` (`contract_address`),
  KEY `block` (`block_height`,`index_in_block`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `receipt_log` (
  `_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `receipt_id` bigint(20) unsigned NOT NULL,
  `log_index` int(10) unsigned NOT NULL,
  `address` binary(20) NOT NULL,
  `topic1` varbinary(32) DEFAULT NULL,
  `topic2` varbinary(32) DEFAULT NULL,
  `topic3` varbinary(32) DEFAULT NULL,
  `topic4` varbinary(32) DEFAULT NULL,
  `data` blob NOT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE KEY `log` (`receipt_id`,`log_index`),
  KEY `contract` (`address`),
  KEY `topic1` (`topic1`),
  KEY `topic2` (`topic2`),
  KEY `topic3` (`topic3`),
  KEY `topic4` (`topic4`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `rich_list` (
  `address_id` bigint(20) unsigned NOT NULL,
  `balance` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`address_id`),
  KEY `balance` (`balance` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tip` (
  `service` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `height` int(10) unsigned NOT NULL,
  `hash` binary(32) NOT NULL,
  PRIMARY KEY (`service`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `transaction` (
  `_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` binary(32) NOT NULL,
  `hash` binary(32) NOT NULL,
  `version` int(11) NOT NULL,
  `flag` tinyint(3) unsigned NOT NULL,
  `lock_time` int(10) unsigned NOT NULL,
  `block_height` int(10) unsigned NOT NULL,
  `index_in_block` int(10) unsigned NOT NULL,
  `size` int(10) unsigned NOT NULL,
  `weight` int(10) unsigned NOT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `block` (`block_height`,`index_in_block`,`_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `transaction_output` (
  `_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `output_transaction_id` varbinary(32) DEFAULT NULL,
  `output_index` int(10) unsigned DEFAULT NULL,
  `scriptpubkey` mediumblob,
  `output_height` int(10) unsigned DEFAULT NULL,
  `input_transaction_id` varbinary(32) DEFAULT NULL,
  `input_index` int(10) unsigned DEFAULT NULL,
  `scriptsig` mediumblob,
  `sequence` int(10) unsigned DEFAULT NULL,
  `input_height` int(10) unsigned DEFAULT NULL,
  `value` bigint(20) NOT NULL,
  `address_id` bigint(20) unsigned NOT NULL,
  `is_stake` tinyint(1) NOT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE KEY `output` (`output_transaction_id`,`output_index`),
  UNIQUE KEY `input` (`input_transaction_id`,`input_index`),
  KEY `rich_list` (`input_height`,`output_height`,`address_id`,`value`),
  KEY `address` (`address_id`,`input_height`,`output_height`,`value`),
  KEY `stake` (`output_height`,`is_stake`,`address_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `witness` (
  `transaction_id` binary(32) NOT NULL,
  `input_index` int(10) unsigned NOT NULL,
  `witness_index` int(10) unsigned NOT NULL,
  `script` blob NOT NULL,
  PRIMARY KEY (`transaction_id`,`witness_index`,`input_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
