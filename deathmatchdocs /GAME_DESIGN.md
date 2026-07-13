# Game Design — Deathmatch Arena

## Controls
- Left thumb: virtual joystick — movement
- Right thumb: 4 buttons — Punch, Kick, Grab, Special
- No combos, no gestures, one-handed playable.

## Meters
| Meter | Behavior |
|---|---|
| ❤️ Health | Standard damage meter. Zero = knockout. |
| ⚡ Stamina | Depletes on attacks/blocks, regenerates when idle. Gates attack spam. |
| ⭐ Hype | Fills as the crowd cheers (landing hits, near-misses, hazard chaos). Spend at max to trigger a finisher. |

## Character roster (MVP — 10 original parody archetypes)

No real names/likenesses. Stats are 1–5 scale (Health / Strength / Speed / Special).

| Archetype | H | S | Sp | Spc | Flavor |
|---|---|---|---|---|---|
| The Action Hero | 4 | 4 | 3 | 3 | All-rounder, explosive special |
| The Pop Diva | 3 | 2 | 5 | 4 | Fast, mic-drop special |
| The Tech Billionaire | 3 | 2 | 3 | 5 | Gadget-based special, weakest melee |
| The Influencer | 2 | 2 | 5 | 3 | Fastest, fragile, crowd-hype bonus |
| The Rockstar | 4 | 4 | 3 | 3 | Guitar-smash special, tanky |
| The Wrestler | 5 | 5 | 2 | 3 | Heaviest hitter, slowest |
| The Conspiracy Host | 3 | 3 | 3 | 4 | Erratic movement pattern, chaos special |
| The Chef | 4 | 3 | 3 | 3 | Balanced, knife-throw special |
| The Billionaire | 3 | 3 | 2 | 5 | Money-cannon special, slow |
| The Super Fan | 3 | 3 | 4 | 4 | Jack-of-all-trades wildcard |

Prototype only needs 2 of these fully built end-to-end (e.g. The Action Hero
vs The Wrestler — good contrast in speed/power) before expanding to the full
10. See BUILD_PLAN.md Phase 3.

## Arenas (MVP — 6, each with a hazard)

| Arena | Hazard |
|---|---|
| Warehouse | Moving cranes, explosive barrels |
| TV Studio | Falling lights, swinging camera cranes |
| Vegas Rooftop | Helicopter wind, billboards |
| Junkyard | Cars, tires, magnets |
| Wrestling Ring | Ropes, crowd, thrown chairs |
| Construction Site | Cement mixers, cranes, falling pipes |

Prototype only needs 1 arena (recommend Wrestling Ring — simplest hazard
logic, most iconic to the genre) before expanding. See BUILD_PLAN.md Phase 3.

Post-MVP candidates from the original brainstorm: Movie Studio (falling
lights), Las Vegas floor (slot machine explosions), Music Festival (speaker
explosions), Space Station (low gravity).

## Finishers
Comedic and exaggerated only — never graphic. Triggered by max Hype + input,
or by an arena hazard timer.

Examples: dropped grand piano, giant boxing glove from the ceiling, shark
jumps into the ring, alien abduction, meteor strike, TNT pile, wrestling
announcer's chair, rocket launch, exploding ring, giant boot.

Prototype needs exactly 1 working finisher end-to-end (trigger → camera zoom
→ VFX/hazard event → forced match end) before adding more.

## Career Mode (post-prototype)
Unknown Influencer → Actors → Musicians → Athletes → Politicians → fictional
parody archetypes → headline event: "The Deathmatch Awards."

## Progression & economy (post-prototype)
- XP, levels, coins from wins / daily login / challenges / optional ads.
- Unlocks: outfits, entrance animations, victory dances, finishers, voice
  packs. **Cosmetic only.**
- Daily challenges: win 3 matches, land 100 punches, perform 5 finishers, win
  without losing.
- Achievements: 100 wins, 500 punches, first finisher, perfect match, win
  streaks.
- Leaderboards: global, friends, country, seasonal.

## Weekly events (post-prototype)
Themed rotations: "Internet Week" (parody influencers), "90s Week" (retro
characters), "Action Movie Week" (explosive arena variant).

## Social / sharing (post-prototype)
Replay system, one-tap share of knockouts/finishers/ragdoll moments,
auto-export as vertical video for TikTok/Reels/Shorts.

## Create-a-Fighter (stretch goal)
Selfie → AI-generated low-poly PS1-style character → customize hairstyle,
outfit, fighting style, voice, special move. Deferred past MVP: needs an
image-generation pipeline, and should only ever generate a character from the
uploaded photo of the person using the app — not from photos of other people
— to avoid creating likenesses without consent.

## Monetization
Free download. Revenue: Battle Pass, cosmetic skins, finishers, emotes, ring
themes, character intros. **No pay-to-win, ever.**

## Art direction
Late-90s MTV energy, reimagined: black backgrounds, chrome borders, electric
blue accents, CRT scanline effects, grungy textures, thick arcade fonts, loud
crowd chants. Main menu: PLAY / MULTIPLAYER / CUSTOMIZE / SHOP / LEADERBOARD /
SETTINGS.
