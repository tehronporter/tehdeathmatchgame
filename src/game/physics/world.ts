import * as CANNON from 'cannon-es';

export const GRAVITY = -9.82;
export const GROUND_SIZE = 12;

export function createMatchWorld(): CANNON.World {
  const world = new CANNON.World({ gravity: new CANNON.Vec3(0, GRAVITY, 0) });
  world.broadphase = new CANNON.SAPBroadphase(world);
  world.allowSleep = false;

  const groundBody = new CANNON.Body({
    type: CANNON.Body.STATIC,
    shape: new CANNON.Plane(),
  });
  groundBody.quaternion.setFromEuler(-Math.PI / 2, 0, 0);
  world.addBody(groundBody);

  return world;
}

export function stepWorld(world: CANNON.World, dt: number) {
  world.step(1 / 60, dt, 3);
}
