const express = require('express');
const exphbs = require('express-handlebars');
const path = require('path');
const routes = require('./routes');

const app = express();
const PORT = 3000;

app.use(express.static(path.join(__dirname, 'public')));

app.engine('hbs', exphbs.engine({ extname: '.hbs', defaultLayout: 'layout' }));
app.set('view engine', 'hbs');

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
app.use('/', routes);

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
