CREATE TABLE "order"(
    orderId         INTEGER     PRIMARY KEY AUTOINCREMENT,
    orderNumber     TEXT        NOT NULL ON CONFLICT FAIL,
    orderDate       TEXT        NOT NULL ON CONFLICT FAIL,
    itemId          INTEGER     NOT NULL ON CONFLICT FAIL,
    customerId      INTEGER     NOT NULL ON CONFLICT FAIL,
    FOREIGN KEY(itemId)     REFERENCES item(itemId),
    FOREIGN KEY(customerId) REFERENCES customer(customerId)
);

CREATE TABLE item(
    itemId          INTEGER     PRIMARY KEY AUTOINCREMENT,
    itemName        TEXT        NOT NULL ON CONFLICT FAIL,
    itemPrice       REAL        NOT NULL ON CONFLICT FAIL,
    manufacturerId  INTEGER     NOT NULL ON CONFLICT FAIL,
    FOREIGN KEY(manufacturerId) REFERENCES manufacturer(manufacturerId)
);
    
CREATE TABLE manufacturer(
    manufacturerId      INTEGER     PRIMARY KEY AUTOINCREMENT,
    manufacturerName    TEXT        NOT NULL ON CONFLICT FAIL
);

CREATE TABLE customer(
    customerId          INTEGER     PRIMARY KEY,
    customerFirstName   TEXT        NOT NULL ON CONFLICT FAIL,
    customerLastName    TEXT        NOT NULL ON CONFLICT FAIL
);

CREATE INDEX purchaseDateNumber ON "order" (orderDate DESC, orderNumber DESC);
