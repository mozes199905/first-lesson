<?php

require './router.php';
require './slugifier.php';

$method = $_SERVER["REQUEST_METHOD"];
$parsed = parse_url($_SERVER['REQUEST_URI']);
$path = $parsed['path'];

// Útvonalak regisztrálása
$routes = [
    // [method, útvonal, handlerFunction],
    ['GET', '/', 'homeHandler'],
    ['GET', '/admin/etel-szerkesztese/{slug}', 'dishEditHandler'],
    ['GET', '/admin', 'adminHandler'],
    ['GET', '/admin/uj-etel-letrehozasa', 'newDish'],
    ['GET', '/admin/etel-tipusok', 'dishType'],
    ['POST', '/login', 'loginHandler'],
    ['POST', '/logout', 'logoutHandler'],
    ['POST', '/create-dish', 'createdDish'],
    ['POST', '/create-dish-type', 'createdDishType'],
    ['POST', '/delete-dish/{dishId}', 'deleteDish'],
    ['POST', '/update-dish/{dishId}', 'updateDish']
];

// Útvonalválasztó inicializálása
$dispatch = registerRoutes($routes);
$matchedRoute = $dispatch($method, $path);
$handlerFunction = $matchedRoute['handler'];
$handlerFunction($matchedRoute['vars']);

// Handler függvények deklarálása
function updateDish($vars)
{
    $dishId = $vars['dishId'];
    $pdo = getConnection();


    if (!isLoggedIn()) {
        echo render("wrapper.phtml", [
            'content' => render('login.phtml')
        ]);
        return;
    }
    $stmt = $pdo->prepare('SELECT * FROM dishes WHERE id = ?');
    $stmt->execute([$dishId]);
    $dish = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$dish) {
        echo "Az étel nem található.";
        return;
    }

    $name = $_POST['name'];
    $slug = $_POST['slug'];
    $description = $_POST['description'];
    $price = $_POST['price'];
    $dishTypeId = $_POST['dishTypeId'];
    $isActive = isset($_POST['isActive']) ? 1 : 0;

    $stmt = $pdo->prepare('UPDATE dishes SET name=?, slug=?, description=?, price=?, isActive=?, dishTypeId=? WHERE id=?');
    $stmt->execute([$name, $slug, $description, $price, $isActive, $dishTypeId, $dishId]);

    header('Location: /admin');
}

function dishEditHandler($vars)
{
    $dishSlug = $vars['slug'];
    $pdo = getConnection();

    $stmt = $pdo->prepare('SELECT * FROM dishes WHERE slug = ?');
    $stmt->execute([$dishSlug]);
    $dish = $stmt->fetch(PDO::FETCH_ASSOC);

    $stmt = $pdo->prepare('SELECT * FROM dishTypes');
    $stmt->execute();
    $dishTypes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!$dish) {
        echo "Az étel nem található.";
        return;
    }

    if (!isLoggedIn()) {
        echo render("wrapper.phtml", [
            'content' => render('login.phtml')
        ]);
        return;
    }

    echo render('admin-wrapper.phtml', [
        'content' => render('edit-dish.phtml', [
            'dish' => $dish,
            'dishTypes' => $dishTypes
        ])
    ]);
}



function deleteDish($vars)
{
    try {
        $dishId = $vars['dishId'];
        // Kapcsolódás az adatbázishoz
        $pdo = getConnection();

        // Lekérdezés összeállítása
        $stmt = $pdo->prepare('DELETE FROM dishes WHERE id = ?');

        // Lekérdezés végrehajtása
        $result = $stmt->execute([$dishId]);

        // Ellenőrzés, hogy a lekérdezés sikeres volt-e
        if (!$result) {
            throw new Exception('Az étel törlése nem sikerült');
        }

        // Átirányítás a főoldalra
        header('Location: /admin');
    } catch (Exception $e) {
        // Hiba kezelése
        echo 'Hiba történt az étel törlése során: ' . $e->getMessage();
    }
}

function createdDishType()
{
    $pdo = getConnection();
    $stmt = $pdo->prepare(
        'INSERT INTO dishTypes (name, slug, description)
        VALUES (?, ?, ?);'
    );

    $result = $stmt->execute([
        $_POST['name'],
        slugify($_POST['name']),
        $_POST['description'],
    ]);

    if ($result === false) {
        $errorInfo = $stmt->errorInfo();
        // Handle the error here
    }

    header('Location: /admin/etel-tipusok');
}

function dishType()
{
    $pdo = getConnection();
    $stmt = $pdo->prepare('SELECT * FROM dishTypes');
    $stmt->execute();
    $dishTypes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!isLoggedIn()) {
        echo render("wrapper.phtml", [
            'content' => render('login.phtml')
        ]);
        return;
    }

    echo render("admin-wrapper.phtml", [
        'content' => render('dish-type-list.phtml', [
            'dishTypes' => $dishTypes
        ])
    ]);
}



function createdDish()
{

    $pdo = getConnection();
    $stmt = $pdo->prepare(
        'INSERT INTO dishes (name, slug, description, price, isActive, dishTypeId)
        VALUES (?, ?, ?, ?, ?, ?);'
    );

    $isActive = isset($_POST['isActive']) ? 1 : 0;

    $result = $stmt->execute([
        $_POST['name'],
        slugify($_POST['name']),
        $_POST['description'],
        $_POST['price'],
        $isActive,
        $_POST['dishTypeId']
    ]);

    if ($result === false) {
        $errorInfo = $stmt->errorInfo();
        // Handle the error here
    }

    header('Location: /');
}



function newDish()
{
    $pdo = getConnection();
    $stmt = $pdo->prepare('SELECT * FROM dishTypes');
    $stmt->execute();
    $dishTypes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!isLoggedIn()) {
        echo render("wrapper.phtml", [
            'content' => render('login.phtml')
        ]);
        return;
    }

    echo render("admin-wrapper.phtml", [
        'content' => render('create-dish.phtml', [
            'dishTypes' => $dishTypes
        ])
    ]);
}



function loginHandler()
{
    $pdo = getConnection();
    $stmt = $pdo->prepare('SELECT * FROM `users` WHERE email = ?');
    $stmt->execute([$_POST['email']]);
    $user = $stmt->fetch();

    if (!$user) {
        echo 'InvalidCredentials';
        return;
    }

    $isVerified = password_verify($_POST['password'], $user['password']);

    if (!$isVerified) {
        echo 'InvalidCredentials';
        return;
    }

    session_start();
    $_SESSION['userId'] = $user['id'];
    header('Location: /admin');
}

function isLoggedIn()
{
    if (!isset($_COOKIE[session_name()])) {
        return false;
    }

    session_start();

    if (!isset($_SESSION['userId'])) {
        return false;
    }

    return true;
}


function adminHandler()
{
    $pdo = getConnection();
    $stmt = $pdo->prepare('SELECT * FROM dishes');
    $stmt->execute();
    $dishes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!isLoggedIn()) {
        echo render("wrapper.phtml", [
            'content' => render('login.phtml')
        ]);
        return;
    }

    echo render('admin-wrapper.phtml', [
        'content' => render('dish-list.phtml', [
            'dishes' => $dishes
        ])
    ]);
}

function homeHandler()
{
    $pdo = getConnection();
    $stmt = $pdo->prepare('SELECT * FROM dishTypes');
    $stmt->execute();
    $dishTypes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($dishTypes as $index => $dishType) {
        $stmt = $pdo->prepare('SELECT * FROM dishes WHERE isActive = 1 AND dishTypeId= ?');
        $stmt->execute([$dishType['id']]);
        $dishes = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $dishTypes[$index]['dishes'] = $dishes;
    }

    echo render("wrapper.phtml", [
        'content' => render('public-menu.phtml', [
            'dishTypes' => $dishTypes
        ])
    ]);
}


function notFoundHandler()
{
    echo 'Oldal nem található';
}

function render($path, $params = [])
{
    ob_start();
    require __DIR__ . '/views/' . $path;
    return ob_get_clean();
}

function getConnection()
{
    return new PDO(
        'mysql:host=' . $_SERVER['DB_HOST'] . ';dbname=' . $_SERVER['DB_NAME'],
        $_SERVER['DB_USER'],
        $_SERVER['DB_PASSWORD']
    );
}

function logoutHandler()
{
    session_start();
    $params = session_get_cookie_params();
    setcookie(session_name(),  '', 0, $params['path'], $params['domain'], $params['secure'], isset($params['httponly']));
    session_destroy();
    header('Location: /');
}
