
<?php

class MovieController
{
    public function __construct(private Movie $model) {}

    // Menampilkan daftar film
    public function index(): void
    {
        $movies = $this->model->getAll();

        $message = $_SESSION['message'] ?? '';
        unset($_SESSION['message']);

        require __DIR__ . '/../views/movie/index.php';
    }

    // Menampilkan form tambah film
    public function create(): void
    {
        $error = '';

        require __DIR__ . '/../views/movie/create.php';
    }

    // Menyimpan film baru
    public function store(): void
    {
        $data = $this->validateInput($_POST);

        if (is_string($data)) {
            $error = $data;
            require __DIR__ . '/../views/movie/create.php';
            return;
        }

        $this->model->insert($data);

        $_SESSION['message'] = 'Data film berhasil ditambahkan.';

        header('Location: index.php');
        exit;
    }

    // Menampilkan form edit film
    public function edit(): void
    {
        $id = (int) ($_GET['id'] ?? 0);

        $movie = $this->model->findById($id);

        if (!$movie) {
            http_response_code(404);
            exit('Data film tidak ditemukan.');
        }

        $error = '';

        require __DIR__ . '/../views/movie/edit.php';
    }

    // Memperbarui data film
    public function update(): void
    {
        $id = (int) ($_POST['id'] ?? 0);

        $movie = $this->model->findById($id);

        if (!$movie) {
            http_response_code(404);
            exit('Data film tidak ditemukan.');
        }

        $data = $this->validateInput($_POST);

        if (is_string($data)) {
            $error = $data;
            $movie = array_merge($movie, $_POST);

            require __DIR__ . '/../views/movie/edit.php';
            return;
        }

        $this->model->update($id, $data);

        $_SESSION['message'] = 'Data film berhasil diperbarui.';

        header('Location: index.php');
        exit;
    }

    // Menghapus data film
    public function delete(): void
    {
        $id = (int) ($_POST['id'] ?? 0);

        if ($id > 0 && $this->model->findById($id)) {
            $this->model->delete($id);

            $_SESSION['message'] = 'Data film berhasil dihapus.';
        } else {
            $_SESSION['message'] = 'Data film tidak ditemukan.';
        }

        header('Location: index.php');
        exit;
    }

    // Validasi input film
    private function validateInput(array $input): array|string
    {
        $data = [
            'judul' => trim($input['judul'] ?? ''),
            'genre' => trim($input['genre'] ?? ''),
            'tahun_rilis' => trim($input['tahun_rilis'] ?? ''),
            'sutradara' => trim($input['sutradara'] ?? ''),
            'durasi' => trim($input['durasi'] ?? '')
        ];

        if (
            $data['judul'] === '' ||
            $data['genre'] === '' ||
            $data['tahun_rilis'] === '' ||
            $data['sutradara'] === '' ||
            $data['durasi'] === ''
        ) {
            return 'Semua kolom wajib diisi.';
        }

        $tahun = filter_var(
            $data['tahun_rilis'],
            FILTER_VALIDATE_INT
        );

        $durasi = filter_var(
            $data['durasi'],
            FILTER_VALIDATE_INT
        );

        if (
            $tahun === false ||
            $tahun < 1888 ||
            $tahun > (int) date('Y')
        ) {
            return 'Tahun rilis tidak valid.';
        }

        if (
            $durasi === false ||
            $durasi < 1 ||
            $durasi > 1000
        ) {
            return 'Durasi film harus antara 1 sampai 1000 menit.';
        }

        $data['tahun_rilis'] = $tahun;
        $data['durasi'] = $durasi;

        return $data;
    }
}

?>
