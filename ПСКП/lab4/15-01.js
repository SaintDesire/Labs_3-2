const express = require('express');
const exphbs  = require('express-handlebars');
const path = require('path');

const app = express();
const PORT = 3000;

// Middleware
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Setting up Handlebars
app.engine('.hbs', exphbs.engine({extname: '.hbs'}));
app.set('view engine', '.hbs');

// Sample JSON data for the phone directory
const phoneDirectory = [
    { name: "John Doe", phone: "123-456-7890" },
    { name: "Jane Smith", phone: "098-765-4321" }
];

// Routes
app.get('/', (req, res) => {
    res.render('home', { directory: phoneDirectory });
});

app.get('/add', (req, res) => {
    res.render('add');
});

app.post('/add', (req, res) => {
    const { name, phone } = req.body;
    phoneDirectory.push({ name, phone });
    res.redirect('/');
});

app.get('/update/:index', (req, res) => {
    const index = req.params.index;
    const entry = phoneDirectory[index];
    res.render('update', { entry, index });
});

app.post('/update/:index', (req, res) => {
    const index = req.params.index;
    const { name, phone } = req.body;
    phoneDirectory[index] = { name, phone };
    res.redirect('/');
});

app.post('/delete/:index', (req, res) => {
    const index = req.params.index;
    phoneDirectory.splice(index, 1);
    res.redirect('/');
});

// Starting the server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
