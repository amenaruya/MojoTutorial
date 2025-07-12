from python import Python, PythonObject
import time
from grid import Grid

fn main() raises:
    var name: String = input("Enter your name: ")
    var greeting: String = String("Hello, {}!").format(name)
    print(greeting)
    time.sleep(1.0)

    # var rows: Int = 8
    # var cols: Int = 8
    var glider: List[List[Int]] = [
        [0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
    ]
    var str1: String = grid_str(glider)
    print()
    print("row list version:")
    print(str1)

    var grid1: Grid = Grid(glider)
    # var str2 = grid1.grid_str()
    var str2: String = String(grid1)
    print()
    print("Grid instance version:")
    print(str2)

    var grid2: Grid = Grid.random(8, 16)
    var str3: String = String(grid2)
    print()
    print("random Grid instance version:")
    print(str3)

    print()
    print("evolving:")
    display(grid2)

    print()
    print("GUI version is now running")
    print("Press 'esc' or 'q' or click × to quit")
    var grid3: Grid = Grid.random(128, 128)
    display(grid3, pause=0)

    print()
    print(String('Farewell, {}').format(name))

fn display(mut grid: Grid) raises -> None:
    while True:
        print(String(grid))
        print()
        if input("Enter 'q' to quit or press <Enter> to continue: ") == "q":
            break
        grid = grid.evolve()

fn display(
    owned grid: Grid,
    pause: Float64,
    window_height: Int = 600,
    window_width: Int = 600,
    background_color: String = "black",
    cell_color: String = "green",
    # pause: Float64 = 0.1,
) raises -> None:
    var pygame: PythonObject = Python.import_module("pygame")
    pygame.init()

    var window: PythonObject = pygame.display.set_mode(
        Python.tuple(window_height, window_width)
    )
    pygame.display.set_caption("Conway's Game of Life")

    var cell_height: SIMD[DType.float64, 1] = window_height / grid.rows
    var cell_width: SIMD[DType.float64, 1] = window_width / grid.cols
    var border_size: Int = 1
    var cell_fill_color: PythonObject = pygame.Color(cell_color)
    var background_fill_color: PythonObject = pygame.Color(background_color)

    var x: SIMD[DType.float64, 1]
    var y: SIMD[DType.float64, 1]
    var width: SIMD[DType.float64, 1]
    var height: SIMD[DType.float64, 1]

    # var running: Bool = True
    # while running:
    while True:
        var event: PythonObject = pygame.event.poll()
        if event.type == pygame.QUIT:
            # running = False
            break
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE or event.key == pygame.K_q:
                # running = False
                break

        window.fill(background_fill_color)

        for row in range(grid.rows):
            for col in range(grid.cols):
                if grid[row, col]:
                    x = col * cell_width + border_size
                    y = row * cell_height + border_size
                    width = cell_width - border_size
                    height = cell_height - border_size
                    pygame.draw.rect(
                        window,
                        cell_fill_color,
                        Python.tuple(x, y, width, height),
                    )

        pygame.display.flip()
        time.sleep(pause)
        grid = grid.evolve()

    pygame.quit()

fn grid_str(
    # rows: Int,
    # cols: Int,
    grid: List[List[Int]]
) -> String:
    var str: String = String()

    var rows: Int = len(grid)
    var cols: Int = len(grid[0])

    for row in range(rows):
        for col in range(cols):
            if grid[row][col] == 1:
                str += "*"
            else:
                str += " "
        if row != rows-1:
            str += "\n"
    return str
