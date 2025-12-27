// for n body gravity simulation
// 10 spheres

const nodes = [];

const COUNT = 10;
const { DEFAULT_COLORED } = encoding.materials();
const { SPHERE } = encoding.shapes();

const code = encoding.levelNodeGASM();
const code_node = code.levelNodeGASM;
code_node.startActive = true;

for (let n = 0; n < COUNT; n++) {
	const obj = encoding.levelNodeStatic();
	const obj_node = obj.levelNodeStatic;
	obj_node.material = DEFAULT_COLORED;
	obj_node.shape = SPHERE;
	obj_node.color1 = { r: 1, g: 1, b: 1 };
	nodes.push(obj);

	encoding.add_code_connection(code, "position", `Obj_${n}`, n + 1);
	encoding.add_code_connection(code, "rotation", `Obj_${n}`, n + 1);
}

level.levelNodes = [...nodes, code];
