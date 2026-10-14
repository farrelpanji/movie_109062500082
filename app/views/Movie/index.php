
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Movie</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    <h1>Movie Database</h1>
    <p>Daftar film yang tersedia</p>

    <?php if (!empty($message)): ?>
        <p class="message">
            <?= htmlspecialchars($message) ?>
        </p>
    <?php endif; ?>

    <a class="button" href="index.php?action=create">
        + Tambah Film
    </a>

    <div class="table-wrap">
        <table>
            <tr>
                <th>No</th>
                <th>Judul Film</th>
                <th>Genre</th>
                <th>Tahun Rilis</th>
                <th>Sutradara</th>
                <th>Durasi</th>
                <th>Aksi</th>
            </tr>

            <?php foreach ($movies as $i => $m): ?>
            <tr>
                <td><?= $i + 1 ?></td>
                <td><?= htmlspecialchars($m['judul']) ?></td>
                <td><?= htmlspecialchars($m['genre']) ?></td>
                <td><?= htmlspecialchars((string) $m['tahun_rilis']) ?></td>
                <td><?= htmlspecialchars($m['sutradara']) ?></td>
                <td><?= htmlspecialchars((string) $m['durasi']) ?> menit</td>
                <td>
                    <a href="index.php?action=edit&id=<?= (int) $m['id'] ?>">
                        Edit
                    </a>

                    <form method="post"
                          action="index.php?action=delete"
                          onsubmit="return confirm('Yakin ingin menghapus film ini?')">

                        <input type="hidden" name="id"
                               value="<?= (int) $m['id'] ?>">

                        <button type="submit">Hapus</button>
                    </form>
                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    </div>
</div>

</body>
</html>
