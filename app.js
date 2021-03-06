const express = require('express');
const database = require('./connection');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');

const app = express();
app.use(bodyParser.json());
app.use(morgan('short'));
app.use(cors({ origin: '*' }));

//|||||||||||||||||||||||||||||||||||||
// setup your db config
//|||||||||||||||||||||||||||||||||||||
const config = {
	host: 'localhost',
	user: 'root',
	password: 'Root123@',
	database: 'burrito'
};

let db = new database(config);

// select the highest bid item
let itemsQuery = `
	SELECT 
		Items.*, 
		max(ItemBids.bid) as highestBid, 
		min(ItemAsks.ask_value) as lowestAsk
	FROM ItemAsks 
			RIGHT JOIN Items ON Items.id = ItemAsks.item_id 
				LEFT JOIN ItemBids ON ItemBids.item_id = Items.id
	GROUP BY Items.id
`;

let allItemsQuery = ` SELECT * FROM Items `;

app.get('/home', (req, res) => {
	db
		.query(itemsQuery)
		.then((rows) => {
			return rows;
		})
		.then((results) => {
			let test = results.map((a) => {
				return {
					id: a.id,
					name: a.name,
					poster: a.poster,
					description: a.description,
					category: a.product_category,
					market: {
						highestBid: a.highestBid,
						lowestAsk: a.lowestAsk
					}
				};
			});
			res.json(test);
		});
});

app.get('/super/allItems', (req, res) => {
	db.query(allItemsQuery).then((results) => {
		res.json(results);
	});
});

app.get('/super/item/:id', (req, res) => {
	let query = `SELECT * FROM Items WHERE id = (?)`;
	let id = req.params.id;
	db.query(query, [ id ]).then((result) => {
		res.json(result);
	});
});

app.get('/super/itemAsks/:id', (req, res) => {
	let query = `SELECT * FROM ItemAsks WHERE item_id = (?)`;
	let id = req.params.id;
	db.query(query, [ id ]).then((result) => {
		res.json(result);
	});
});

app.get('/super/itemBids/:id', (req, res) => {
	let query = `SELECT * FROM ItemBids WHERE item_id = (?)`;
	let id = req.params.id;
	db.query(query, [ id ]).then((result) => {
		res.json(result);
	});
});

app.post('/super/createItem', (req, res) => {
	const { name, poster, description, category } = req.body;
	console.log('testing', req.body);
	const queryString = `INSERT INTO Items (name, poster, description, product_category) VALUES (?,?,?,?)`;
	db.query(queryString, [ name, poster, description, category ]).then((err, results) => {
		if (err) console.log('Failed to insert new item');
		res.end();
	});
});

app.post('/user/placeAsk', (req, res) => {
	const { item_id, ask_value, seller } = req.body;
	const query = `INSERT INTO ItemAsks (ask_value, seller, item_id) VALUES (?,?,?)`;
	db.query(query, [ ask_value, seller, item_id ]).then((err, results) => {
		if (err) console.log('Failed to place ask');
		res.end();
	});
});

app.post('/user/placeBid', (req, res) => {
	const { bid, bidder, item_id } = req.body;
	const query = `INSERT INTO ItemBids (bid, bidder, item_id) VALUES (?,?,?)`;
	db.query(query, [ bid, bidder, item_id ]).then((err, results) => {
		if (err) console.log('Failed to place bid');
		res.end();
	});
});

app.delete('/super/deleteItem/:id', (req, res) => {
	let id = req.params.id;
	const queryString = `DELETE FROM Items WHERE id = (?)`;
	db.query(queryString, [ id ]).then((err) => {
		if (err) console.log(err);
		res.end();
	});
});

app.put('/super/updateItem/:id', (req, res) => {
	let id = req.params.id;
	let { name, poster, description, category } = req.body;

	const queryString = `UPDATE Items SET name = ?, poster = ?, description= ?, product_category = ? WHERE id = ?`;
	db.query(queryString, [ name, poster, description, category, id ]).then((err) => {
		if (err) console.log(err);
		res.end();
	});
});
app.get('/', (req, res) => {
	res.send('BurritoX');
});
const port = 5000;
app.listen(port, () => console.log(`Server running on port ${port}`));
