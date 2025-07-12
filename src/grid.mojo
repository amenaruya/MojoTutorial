import random

# @fieldwise_init
struct Grid(Copyable, Movable, StringableRaising):
    var rows: Int
    var cols: Int
    var data: List[List[Int]]

    fn __init__(
        out self,
        # rows: Int,
        # cols: Int,
        data: List[List[Int]]
    ):
        self.data = data
        self.rows = len(data)
        self.cols = len(data[0])

    # fn grid_str(self) -> String:
    fn __str__(self) raises -> String: # StringableRaisingの継承による
        var str: String = String()

        for row in range(self.rows):
            for col in range(self.cols):
                # if self.data[row][col] == 1:
                if self[row, col] == 1: # __getitem__による
                    str += "*"
                else:
                    str += " "
            if row != self.rows - 1:
                str += "\n"

        return str

    fn __getitem__(self, row: Int, col: Int) -> Int:
        return self.data[row][col]

    fn __setitem__(mut self, row: Int, col: Int, value: Int) -> None:
        self.data[row][col] = value

    @staticmethod
    fn random(rows: Int, cols: Int) -> Self:
        random.seed()
        var data: List[List[Int]] = []

        for _ in range(rows):
            var row_data: List[Int] = []
            for _ in range(cols):
                row_data.append(Int(random.random_si64(0, 1)))
            data.append(row_data)

        return Self(
            # rows,
            # cols,
            data
        )

    fn evolve(self) -> Self:
        var next_generation: List[List[Int]] = List[List[Int]]()
        var row_data: List[Int]
        var row_above: Int
        var row_below: Int
        var col_left: Int
        var col_right: Int
        var num_neighbors: Int
        var new_state: Int

        for row in range(self.rows):
            row_data = List[Int]()

            row_above = (row - 1) % self.rows
            row_below = (row + 1) % self.rows

            for col in range(self.cols):
                col_left = (col - 1) % self.cols
                col_right = (col + 1) % self.cols

                num_neighbors = (
                    self[row_above, col_left]
                    + self[row_above, col]
                    + self[row_above, col_right]
                    + self[row, col_left]
                    + self[row, col_right]
                    + self[row_below, col_left]
                    + self[row_below, col]
                    + self[row_below, col_right]
                )

                new_state = 0
                if self[row, col] == 1 and (num_neighbors == 2 or num_neighbors == 3):
                    new_state = 1
                elif self[row, col] == 0 and num_neighbors == 3:
                    new_state = 1
                row_data.append(new_state)

            next_generation.append(row_data)

        return Self(
            # self.rows,
            # self.cols,
            next_generation
        )
