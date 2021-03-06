USER [db];

SELECT * FROM Users
SELECT * FROM Items

CREATE TABLE Users(
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(128),
    email VARCHAR(128),
    user_type VARCHAR(128),
    PRIMARY KEY (id)
);

CREATE TABLE Items(
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(128),
    poster VARCHAR(255),
    description VARCHAR(255),
    product_category VARCHAR(128),
    PRIMARY KEY (id)
);

CREATE TABLE ItemBids(
    bid_id INTEGER NOT NULL AUTO_INCREMENT,
    bid INTEGER,
    bidder INTEGER,
    item_id INTEGER,
    PRIMARY KEY (bid_id),
    FOREIGN KEY (bidder) REFERENCES Users(id),
    FOREIGN KEY (item_id) REFERENCES Items(id)
)

INSERT INTO ItemBids(bid, bidder, item_id) VALUES (153,1,1)
INSERT INTO ItemBids(bid, bidder, item_id) VALUES (175,1,1)
INSERT INTO ItemBids(bid, bidder, item_id) VALUES(135, 1,1)
INSERT INTO ItemBids(bid, bidder, item_id) VALUES(120, 2, 1)
INSERT INTO ItemBids(bid, bidder, item_id) VALUES(120, 2, 2)



CREATE TABLE ItemAsks(
    ask_id INTEGER NOT NULL AUTO_INCREMENT,
    ask_value INTEGER,
    seller INTEGER,
    item_id INTEGER,
    PRIMARY KEY (ask_id),
    FOREIGN KEY (seller) REFERENCES Users(id),
    FOREIGN KEY (item_id) REFERENCES Items(id)
)


INSERT INTO ItemAsks(ask_value, seller, item_id) VALUES (130,1,1)
INSERT INTO ItemAsks(ask_value, seller, item_id) VALUES (150,1,1)
INSERT INTO ItemAsks(ask_value, seller, item_id) VALUES(175, 1,1)
INSERT INTO ItemAsks(ask_value, seller, item_id) VALUES(165, 2,1)


	SELECT Items.*,
	max(ItemBids.bid) AS highestBid,
	min(ItemAsks.ask_value) AS lowestAsk
	FROM ItemAsks
	INNER JOIN Items ON Items.id = ItemAsks.item_id
	INNER JOIN ItemBids ON Itembids.item_id = ItemAsks.item_id
	GROUP BY Items.id  

SELECT *, ItemAsks.ask_value FROM Items
	left JOIN ItemAsks ON ItemAsks.item_id = Items.id

INSERT INTO Users (name, email, user_type) VALUES (
    'Luis Castillo', 
    'test@gmail.com',
    'ordinary'
);

INSERT INTO Users (name, email, user_type) VALUES (
    'Yorli Chazari', 
    'test@gmail.com',
    'ordinary'
);




INSERT INTO Items (name, poster, description, product_category, seller_id) VALUES (
    "Supreme Creeper Tee Black",
    "https://stockx.imgix.net/products/streetwear/Supreme-Creeper-Tee-Black.jpg?fit=fill&bg=FFFFFF&w=700&h=500&auto=format,compress&q=90&trim=color&updated_at=1550765840&w=1900",
    "Latest Supreme Creeper",
    "supreme",
    1
)

INSERT INTO Items (name, poster, description, product_category, seller_id) VALUES (
    "Supreme Warm Up Hockey Jersey Black",
    "https://stockx.imgix.net/products/streetwear/Supreme-Warm-Up-Hockey-Jersey-Black.jpg?fit=fill&bg=FFFFFF&w=700&h=500&auto=format,compress&q=90&trim=color&updated_at=1538659333&w=1900",
    "Latest Supreme Warm Up Hockey Jersey Black",
    "supreme",
    2
)



/* Aggregate query example */

-- select orderNumber, sum(quantity)
-- from orderDetails 
-- group by orderNumber 
-- order by sum(quantyOrdered)

-- ||||||||||||||||||||||||||||||||||||||

-- select max(quantityOrdered)
-- from orderDetails

-- ||||||||| SUB QUERY |||||||||||

-- select customerNumber, sum(amount)
-- from payments
-- where amount > (
--     select avg(amount)
--     from payments
-- )
-- group by customerNumber;