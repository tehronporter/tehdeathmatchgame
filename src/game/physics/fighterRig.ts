import * as CANNON from 'cannon-es';

export interface FighterRig {
  torso: CANNON.Body;
  head: CANNON.Body;
  neck: CANNON.ConeTwistConstraint;
}

export function createFighterRig(world: CANNON.World, x: number): FighterRig {
  const torso = new CANNON.Body({
    mass: 5,
    shape: new CANNON.Box(new CANNON.Vec3(0.4, 0.6, 0.3)),
    position: new CANNON.Vec3(x, 1, 0),
    linearDamping: 0.7,
    angularDamping: 0.9,
    fixedRotation: true,
  });
  world.addBody(torso);

  const head = new CANNON.Body({
    mass: 1,
    shape: new CANNON.Sphere(0.28),
    position: new CANNON.Vec3(x, 1.9, 0),
    linearDamping: 0.5,
    angularDamping: 0.5,
  });
  world.addBody(head);

  const neck = new CANNON.ConeTwistConstraint(torso, head, {
    pivotA: new CANNON.Vec3(0, 0.6, 0),
    pivotB: new CANNON.Vec3(0, -0.28, 0),
    axisA: CANNON.Vec3.UNIT_Y,
    axisB: CANNON.Vec3.UNIT_Y,
    angle: Math.PI / 6,
    twistAngle: Math.PI / 8,
  });
  world.addConstraint(neck);

  return { torso, head, neck };
}

export function knockHead(rig: FighterRig, direction: 1 | -1, magnitude: number) {
  rig.head.applyImpulse(new CANNON.Vec3(direction * magnitude, magnitude * 0.3, 0));
}

export function moveTorso(rig: FighterRig, x: -1 | 0 | 1, speed: number) {
  rig.torso.velocity.x = x * speed;
}
