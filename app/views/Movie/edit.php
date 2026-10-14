
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Film</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    <h1>Edit Film</h1>
    <p>Ubah informasi film di bawah ini.</p>

    <?php if (!empty($error)): ?>
        <p class="error">
            <?= htmlspecialchars($error) ?>
        </p>
    <?php endif; ?>

    <form method="post" action="index.php?action=update">

        <input type="hidden" name="id"
               value="<?= (int) $movie['id'] ?>">

        <label>Judul Film</label>
        <input type="text" name="judul"
               value="<?= htmlspecialchars($movie['judul']) ?>"
               required>

        <label>Genre</label>
        <input type="text" name="genre"
               value="<?= htmlspecialchars($movie['genre']) ?>"
               required>

        <label>Tahun Rilis</label>
        <input type="number" name="tahun_rilis"
               min="1888" max="<?= date('Y') ?>"
               value="<?= htmlspecialchars((string) $movie['tahun_rilis']) ?>"
               required>

        <label>Sutradara</label>
        <input type="text" name="sutradara"
               value="<?= htmlspecialchars($movie['sutradara']) ?>"
               required>

        <label>Durasi (menit)</label>
        <input type="number" name="durasi" min="1" max="1000"
               value="<?= htmlspecialchars((string) $movie['durasi']) ?>"
               required>

        <button type="submit">Simpan Perubahan</button>
        <a href="index.php">Kembali</a>
    </form>
</div>

</body>
</html>
