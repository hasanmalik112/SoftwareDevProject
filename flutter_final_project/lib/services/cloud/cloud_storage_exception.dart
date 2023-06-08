class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateItemException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllItemsException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateItemException extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteItemException extends CloudStorageException {}

class CouldNotDeleteTransactionException extends CloudStorageException {}

class CouldNotGetAllTransactionException extends CloudStorageException {}

class CouldNotDeleteTransactionsException extends CloudStorageException {}
