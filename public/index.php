
<?php

session_start();

require __DIR__ . '/../config/database.php';
require __DIR__ . '/../app/models/Movie.php';
require __DIR__ . '/../app/controllers/MovieController.php';

$db = (new Database())->connect();

$model = new Movie($db);

$controller = new MovieController($model);

$action = $_GET['action'] ?? 'index';

match ($action) {
    'index' => $controller->index(),
    'create' => $controller->create(),
    'store' => $controller->store(),
    'edit' => $controller->edit(),
    'update' => $controller->update(),
    'delete' => $controller->delete(),

    default => (function () {
        http_response_code(404);
        exit('Action tidak ditemukan.');
    })()
};

?>
