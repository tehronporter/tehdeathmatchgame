import { Canvas } from '@react-three/fiber';

export function BlankScene() {
  return (
    <Canvas camera={{ position: [0, 1.6, 5], fov: 50 }}>
      <color attach="background" args={['#000000']} />
      <ambientLight intensity={0.6} />
      <directionalLight position={[3, 5, 2]} intensity={1.2} />
      <mesh position={[0, 0.5, 0]} rotation={[0.4, 0.6, 0]}>
        <boxGeometry args={[1, 1, 1]} />
        <meshStandardMaterial color="#1e6bff" />
      </mesh>
      <mesh position={[0, -0.5, 0]} rotation={[-Math.PI / 2, 0, 0]}>
        <planeGeometry args={[10, 10]} />
        <meshStandardMaterial color="#111111" />
      </mesh>
    </Canvas>
  );
}
