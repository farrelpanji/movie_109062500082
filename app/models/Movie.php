
<?php

class Movie
{
    public function __construct(private PDO $db) {}

    // Menampilkan semua data film
    public function getAll(): array
    {
        $stmt = $this->db->query(
            'SELECT id, judul, genre, tahun_rilis, sutradara, durasi
             FROM movies
             ORDER BY judul'
        );

        return $stmt->fetchAll();
    }

    // Mencari film berdasarkan ID
    public function findById(int $id): array|false
    {
        $stmt = $this->db->prepare(
            'SELECT id, judul, genre, tahun_rilis, sutradara, durasi
             FROM movies
             WHERE id = :id'
        );

        $stmt->execute([':id' => $id]);

        return $stmt->fetch();
    }

    // Menambahkan data film
    public function insert(array $data): bool
    {
        $sql = 'INSERT INTO movies
                (judul, genre, tahun_rilis, sutradara, durasi)
                VALUES
                (:judul, :genre, :tahun_rilis, :sutradara, :durasi)';

        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            ':judul' => $data['judul'],
            ':genre' => $data['genre'],
            ':tahun_rilis' => $data['tahun_rilis'],
            ':sutradara' => $data['sutradara'],
            ':durasi' => $data['durasi']
        ]);
    }

    // Mengubah data film
    public function update(int $id, array $data): bool
    {
        $sql = 'UPDATE movies
                SET judul = :judul,
                    genre = :genre,
                    tahun_rilis = :tahun_rilis,
                    sutradara = :sutradara,
                    durasi = :durasi
                WHERE id = :id';

        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            ':id' => $id,
            ':judul' => $data['judul'],
            ':genre' => $data['genre'],
            ':tahun_rilis' => $data['tahun_rilis'],
            ':sutradara' => $data['sutradara'],
            ':durasi' => $data['durasi']
        ]);
    }

    // Menghapus data film
    public function delete(int $id): bool
    {
        $stmt = $this->db->prepare(
            'DELETE FROM movies WHERE id = :id'
        );

        return $stmt->execute([':id' => $id]);
    }
}

?>
