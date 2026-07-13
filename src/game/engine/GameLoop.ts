const FIXED_STEP_MS = 1000 / 60;
const MAX_STEPS_PER_FRAME = 5;

export type TickFn = (dt: number) => void;

export class GameLoop {
  private accumulator = 0;
  private lastTime = 0;
  private running = false;
  private frameHandle: number | null = null;

  constructor(private readonly tick: TickFn) {}

  start() {
    if (this.running) return;
    this.running = true;
    this.lastTime = now();
    this.frameHandle = requestAnimationFrame(this.frame);
  }

  stop() {
    this.running = false;
    if (this.frameHandle !== null) {
      cancelAnimationFrame(this.frameHandle);
      this.frameHandle = null;
    }
  }

  private frame = () => {
    if (!this.running) return;

    const current = now();
    const elapsed = current - this.lastTime;
    this.lastTime = current;
    this.accumulator += elapsed;

    let steps = 0;
    while (this.accumulator >= FIXED_STEP_MS && steps < MAX_STEPS_PER_FRAME) {
      this.tick(FIXED_STEP_MS / 1000);
      this.accumulator -= FIXED_STEP_MS;
      steps += 1;
    }
    if (steps === MAX_STEPS_PER_FRAME) {
      this.accumulator = 0;
    }

    this.frameHandle = requestAnimationFrame(this.frame);
  };
}

function now() {
  return typeof performance !== 'undefined' ? performance.now() : Date.now();
}
