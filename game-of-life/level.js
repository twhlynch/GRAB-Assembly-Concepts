// for conways game of life
// 30 x 30 grid of black cells and a white wall

const nodes = [];

const SIZE = 30;
const { DEFAULT_COLORED } = encoding.materials();

const wall = encoding.levelNodeStatic();
const wall_node = wall.levelNodeStatic;
wall_node.position = { x: SIZE / 2 - 0.5, y: SIZE / 2 - 0.5, z: 0.1 };
wall_node.scale = { x: SIZE, y: SIZE, z: 1 };
wall_node.material = DEFAULT_COLORED;
wall_node.color1 = { r: 1, g: 1, b: 1 };

const code = encoding.levelNodeGASM();
const code_node = code.levelNodeGASM;
code_node.startActive = true;
code_node.position.z = -10;

for (let x = 0; x < SIZE; x++) {
	for (let y = 0; y < SIZE; y++) {
		const cell = encoding.levelNodeStatic();
		const cell_node = cell.levelNodeStatic;
		cell_node.position = { x, y };
		cell_node.material = DEFAULT_COLORED;
		nodes.push(cell);

		encoding.add_code_connection(
			code,
			"position",
			`Cell_${x}_${y}`,
			y + x * SIZE + 1,
		);
	}
}

level.levelNodes = [...nodes, wall, code];
