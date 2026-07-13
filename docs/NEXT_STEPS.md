# Next Steps — The Definitive Plan

This is the authoritative go-forward plan, replacing the ad-hoc ordering in
BUILD_PLAN.md's post-prototype phases. It folds in (a) the current build's
real state, (b) research on the reference game *MTV's Celebrity Deathmatch*
(2003), and (c) the existing PRD/GAME_DESIGN intent.

Work top to bottom. Phase 0 is a hard blocker — nothing below it is visible
until it's done.

---

## Reference study — *MTV's Celebrity Deathmatch* (2003)

What we're emulating (feel + presentation), and what we're deliberately
improving on. Sources at bottom.

**Core combat loop (validates our design):**
- Damage the opponent until their life meter flashes red and **"KILL!"**
  appears — a distinct *near-death* state.
- *Then* fill the **MTV meter** (their crowd-hype bar) — built by landing
  hits and **taunting** the crowd.
- With the meter full + opponent in the KILL state, trigger a
  **character-specific finisher** (e.g. Mr. T drops the A-Team van; a fighter
  rips out a ribcage and plays it like a xylophone — cartoon gore, played for
  laughs).
- **Takeaway:** their MTV meter == our **Hype** meter. Adopt their **two-stage
  KO**: you can't just fill a bar to win — you must weaken the opponent to a
  "FINISH!" state first, then the finisher is the exclamation point.

**Taunting is a mechanic, not flavor:** the taunt button builds the meter *and*
grants brief invincibility, rewarding aggression. Our control scheme is locked
to joystick + 4 buttons (Punch/Kick/Grab/Special), so we fold "taunt" into
Hype-on-landed-hits / near-miss (already designed) rather than adding a button.

**It's a 2.5D side-view ring brawler**, not a free-roaming 3D arena. Fixed-ish
side camera, two fighters facing each other in a roped ring. Our camera model
should commit to this.

**Known weakness we will beat:** reviewers criticized that "the game lacks
hazards within the squared circle" (one arena had lava you couldn't interact
with). Our PRD promises a *real, interactive* hazard per arena — that's our
differentiator. Make hazards actually dangerous and reactive.

**Signature presentation to match:**
- Portrait-card character select (framed 3D character renders, not abstract
  swatches).
- A distinct **VS screen**: big 1P/CPU portraits, "VS.", a roster grid with
  locked "?" slots (teases unlocks) and a "Create-a-Fighter" slot.
- **Two-commentator announcer** (Johnny Gomez & Nick Diamond in the original) —
  we do an original parody pair.
- **MTV-branded chrome HUD**: chunky branded health/stamina bars bottom-left /
  bottom-right, framed in a metallic TV-set border.

**Legal, restated:** the reference uses real celebrities. We use **original
parody archetypes only** — the presentation and feel, never the likenesses.

---

## Phase 0 — Unblock: make the game visible (HARD BLOCKER)

The fight screen currently renders **pure black** — the expo-gl /
react-three-fiber `<Canvas>` isn't painting at all (not even the arena
background color). Nothing else on this list matters until this is fixed.

- [ ] Fix the black `<Canvas>`. Diagnose expo-gl `GLView` under React Native's
      New Architecture (Fabric, default in SDK 57): test a minimal r3f scene,
      confirm the GLView mounts and is sized, check `frameloop`/`gl` props. If
      expo-gl proves unworkable under Fabric, escalate the render-engine
      decision (this is the one scenario that reopens Option A vs B).
- [ ] Fix `MeterBar` fill — it animates `width` to a percentage string via
      Reanimated `withTiming`, which doesn't interpolate; bars read empty even
      at full health. Switch to a flex-based or measured-pixel fill.
- [ ] Fix character-select layout — cards currently stretch to full screen
      height as thin columns. Constrain card size.

**Done when:** you can tap PLAY → select → see two fighters in a lit scene,
with health/stamina/hype bars that visibly fill, and play a match to a result.

---

## Phase 1 — Core match feel (2.5D ring brawler parity)

Make the fight read and feel like the reference's ring combat.

- [ ] Commit the camera to a fixed side-on 2.5D fighting view.
- [ ] Build the ring: floor, ropes, corner posts, lateral boundaries the
      fighters can't walk past.
- [ ] Fighter facing (always face the opponent), approach/spacing, distinct
      hit reactions, knockback, stamina-gated attacks.
- [ ] **Two-stage KO:** damage → opponent enters a "FINISH!" (near-death)
      state (meter flashes) → Hype-triggered finisher ends it. Wire this into
      the existing match state machine.
- [ ] MTV-style HUD: chunky branded Health/Stamina/Hype bars anchored
      bottom-left / bottom-right with a logo motif (replaces the thin top bars).

---

## Phase 2 — Presentation flow (the screens)

- [ ] Character select as portrait cards (stylized portrait/silhouette per
      archetype, stat bars instead of "H4 S4" text).
- [ ] Distinct **VS screen**: big 1P/CPU portraits, "VS.", roster grid with
      locked "?" slots and a Create-a-Fighter slot (tease only for now).
- [ ] Opponent + arena selection (currently hardcoded Action Hero vs Wrestler
      in Wrestling Ring).
- [ ] Results / KO payoff screen: winner pose, match stats, XP-gain animation.
- [ ] Announcer commentary hook: an original two-commentator parody pair —
      text barks first, audio later (Phase 6 sound pass).

---

## Phase 3 — Character & arena identity

- [ ] Upgrade fighters from boxes to expressive **oversized-head low-poly**
      silhouettes (proportions per PRD: big head, exaggerated hands, tiny
      body) — placeholder-but-characterful before real assets exist.
- [ ] Arena dressing: crowd, overhead lighting rig, per-arena props
      (junkyard barrels, warehouse machinery, ring corner pads).
- [ ] **Interactive hazards** — the reference's weak point. Each arena's hazard
      must actually trigger, be visible (sparks/pyro/falling objects), and deal
      damage to whoever's in range. (Wrestling Ring: thrown chair; others per
      GAME_DESIGN.)
- [ ] (Optional, reference-authentic) pickup weapons from crates (chair, etc.):
      grab + attack for bonus damage.

---

## Phase 4 — Deathmatch juice & finishers (the payoff)

- [ ] Real finisher sequences per character: camera zoom + slow-mo + cartoon
      VFX / gore gag (never graphic) → forced match end. Currently just a text
      banner + screen shake.
- [ ] Hit sparks, cartoon impact FX, ragdoll on KO (we already have screen
      shake and a torso+head rig to build ragdoll from).
- [ ] Crowd + announcer reactions tied to Hype level and big hits.

---

## Phase 5 — MTV art direction

- [ ] Chrome / TV-set framed UI, CRT scanline overlay, thick arcade font,
      grunge textures, electric-blue accents, animated title. (Current UI is a
      clean but generic dark/blue placeholder.)

---

## Phase 6 — Content & systems

- [ ] All 10 archetypes and 6 arenas fully distinct and playable.
- [ ] 4 AI difficulty tiers wired to selectable difficulty (profiles already
      exist in `src/game/ai/difficulty.ts`).
- [ ] Career mode (Unknown Influencer → … → "The Deathmatch Awards").
- [ ] Shop: coins already accrue with nothing to spend them on — ship a minimal
      cosmetic shop (color/outfit skins) or hide it until then.
- [ ] Full sound pass: impact SFX, music bed, crowd, announcer VO.

---

## Phase 7 — Real assets & ship (big lifts / blocked on you)

- [ ] Real low-poly 3D character/arena models — needs an art-source decision
      (commission, marketplace pack, or AI mesh-gen). This is the largest open
      item and gates the "PS1 low-poly" promise.
- [ ] **Supabase online** (multiplayer/leaderboards) — schema + client are
      scaffolded but inert; needs a real Supabase project + keys. Yours to set
      up; I won't create accounts on your behalf.
- [ ] **TestFlight** — needs `eas login` against your Apple Developer Program
      account. Yours to authorize.

---

## Recommended immediate next action
Start Phase 0.1 — diagnose and fix the black `<Canvas>`. It's the single thing
standing between the current build and a playable prototype, and every other
item here is invisible until it's fixed.

---

## Sources
- [Celebrity Deathmatch (video game) — Wikipedia](https://en.wikipedia.org/wiki/Celebrity_Deathmatch_(video_game))
- [MTV's Celebrity Deathmatch — Move List and Guide (GameFAQs)](https://gamefaqs.gamespot.com/ps2/561440-mtvs-celebrity-deathmatch/faqs/26444)
- [MTV Celebrity Deathmatch (2003) — MobyGames](https://www.mobygames.com/game/13489/mtv-celebrity-deathmatch/)
