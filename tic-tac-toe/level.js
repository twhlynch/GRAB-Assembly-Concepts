// for tic tac toe
// 3x3 Xs, Os, & triggers, and a wall and 2 win walls

const nodes = [];

const { DEFAULT_COLORED } = encoding.materials();
const { SPHERE, CUBE } = encoding.shapes();
const { HAND, GRAPPLE } = encoding.load().COD.Level.TriggerSourceBasic.Type;

const code = encoding.levelNodeGASM();
const code_node = code.levelNodeGASM;
code_node.position.x = -2;
code_node.startActive = true;

["X", "O"].forEach((l) => {
	for (let x = 0; x < 3; x++) {
		for (let y = 0; y < 3; y++) {
			const obj = encoding.levelNodeStatic();
			const obj_node = obj.levelNodeStatic;
			obj_node.material = DEFAULT_COLORED;
			obj_node.shape = l == "O" ? SPHERE : CUBE;
			obj_node.color1 = l == "O" ? { r: 1 } : { b: 1 };
			obj_node.position = { x: x, y: y };
			obj_node.scale = { x: 0.8, y: 0.8, z: 1.1 };
			nodes.push(obj);

			encoding.add_code_connection(
				code,
				"position",
				`${l}_${x}_${y}`,
				nodes.length,
			);
		}
	}
});

for (let x = 0; x < 3; x++) {
	for (let y = 0; y < 3; y++) {
		const trigger = encoding.levelNodeTrigger();
		const trigger_node = trigger.levelNodeTrigger;
		trigger_node.position = { x: x, y: y, z: 1 };
		trigger_node.scale = { x: 0.8, y: 0.8, z: 1.5 };

		const hand_source = encoding.triggerSourceBasic();
		hand_source.triggerSourceBasic.type = HAND;
		const grapple_source = encoding.triggerSourceBasic();
		grapple_source.triggerSourceBasic.type = GRAPPLE;
		trigger_node.triggerSources.push(hand_source, grapple_source);

		nodes.push(trigger);

		const name = `T_${x}_${y}`;
		const id = nodes.length;
		encoding.add_code_connection(code, "position", name, id);
		encoding.add_code_connection(code, "active", name, id);
	}
}

const xwin = encoding.levelNodeStatic();
const xwin_node = xwin.levelNodeStatic;
xwin_node.material = DEFAULT_COLORED;
xwin_node.position = { x: 1, y: 1 };
xwin_node.scale = { x: 3.2, y: 3.2, z: 0.99 };

const owin = encoding.deepClone(xwin);
const owin_node = owin.levelNodeStatic;
owin_node.color1 = { r: 1 };

nodes.push(xwin);
encoding.add_code_connection(code, "position", `Xwin`, nodes.length);
nodes.push(owin);
encoding.add_code_connection(code, "position", `Owin`, nodes.length);

const wall = encoding.levelNodeStatic();
const wall_node = wall.levelNodeStatic;
wall_node.material = DEFAULT_COLORED;
wall_node.color1 = { r: 1, g: 1, b: 1 };
wall_node.position = { x: 1, y: 1, z: 1 };
wall_node.scale = { x: 3, y: 3, z: 1 };

level.levelNodes = [...nodes, wall, code];
