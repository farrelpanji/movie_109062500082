
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Film</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    <h1>Tambah Film</h1>
    <p>Masukkan informasi film baru.</p>

    <?php if (!empty($error)): ?>
        <p class="error">
            <?= htmlspecialchars($error) ?>
        </p>
    <?php endif; ?>

    <form method="post" action="index.php?action=store">
        <label>Judul Film</label>
        <input type="text" name="judul"
               value="<?= htmlspecialchars($_POST['judul'] ?? '') ?>"
               required>

        <label>Genre</label>
        <input type="text" name="genre"
               value="<?= htmlspecialchars($_POST['genre'] ?? '') ?>"
               required>

        <label>Tahun Rilis</label>
        <input type="number" name="tahun_rilis"
               min="1888" max="<?= date('Y') ?>"
               value="<?= htmlspecialchars($_POST['tahun_rilis'] ?? '') ?>"
               required>

        <label>Sutradara</label>
        <input type="text" name="sutradara"
               value="<?= htmlspecialchars($_POST['sutradara'] ?? '') ?>"
               required>

        <label>Durasi (menit)</label>
        <input type="number" name="durasi" min="1" max="1000"
               value="<?= htmlspecialchars($_POST['durasi'] ?? '') ?>"
               required>

        <button type="submit">Simpan Film</button>
        <a href="index.php">Kembali</a>
    </form>
</div>

</body>
</html>
