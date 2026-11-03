<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Zombie Arena Box</title>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      user-select: none;
    }

    body {
      background: #111;
      color: #fff;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      display: flex;
      flex-direction: column;
      align-items: center;
      min-height: 100vh;
      padding: 10px;
    }

    h1 {
      margin-bottom: 5px;
      color: #e74c3c;
      text-shadow: 0 0 10px rgba(231, 76, 60, 0.5);
    }

    /* Config Panel */
    .config-panel {
      background: #222;
      padding: 10px 15px;
      border-radius: 8px;
      margin-bottom: 10px;
      display: flex;
      gap: 15px;
      flex-wrap: wrap;
      align-items: center;
      border: 1px solid #444;
      max-width: 900px;
      width: 100%;
    }

    .config-group {
      display: flex;
      flex-direction: column;
      font-size: 12px;
      flex: 1;
      min-width: 180px;
    }

    .config-group label {
      margin-bottom: 3px;
      color: #aaa;
    }

    .config-group input {
      background: #333;
      border: 1px solid #555;
      color: #fff;
      padding: 5px;
      border-radius: 4px;
      font-size: 11px;
    }

    /* Layout */
    .game-container {
      display: flex;
      gap: 15px;
      max-width: 1100px;
      width: 100%;
    }

    /* Canvas Arena */
    #arena {
      background: #1e1e1e;
      border: 4px solid #444;
      box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
      cursor: crosshair;
      border-radius: 4px;
    }

    /* UI Sidebar */
    .sidebar {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .card {
      background: #222;
      border: 1px solid #333;
      padding: 12px;
      border-radius: 6px;
    }

    .card h3 {
      color: #f39c12;
      margin-bottom: 8px;
      font-size: 16px;
      border-bottom: 1px solid #444;
      padding-bottom: 4px;
    }

    .stat-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 6px;
      font-size: 14px;
    }

    .bar-bg {
      background: #444;
      height: 12px;
      border-radius: 6px;
      overflow: hidden;
      margin-top: 2px;
    }

    .bar-fill {
      height: 100%;
      width: 100%;
      transition: width 0.1s;
    }

    #hp-fill {
      background: #e74c3c;
    }

    #xp-fill {
      background: #3498db;
    }

    /* Shop Buttons */
    .shop-btn {
      width: 100%;
      background: #27ae60;
      color: white;
      border: none;
      padding: 8px;
      margin-top: 6px;
      border-radius: 4px;
      cursor: pointer;
      font-weight: bold;
      transition: background 0.2s;
      display: flex;
      justify-content: space-between;
    }

    .shop-btn:hover {
      background: #2ecc71;
    }

    .shop-btn:disabled {
      background: #555;
      cursor: not-allowed;
      opacity: 0.6;
    }

    /* Controls Overlay */
    .controls-hint {
      font-size: 12px;
      color: #888;
      margin-top: 5px;
      text-align: center;
    }
  </style>
</head>

<body>

  <h1>ZOMBIE BOX ARENA</h1>

  <!-- Image Configuration Inputs -->
  <div class="config-panel">
    <div class="config-group">
      <label for="img-player">Player Image URL / Path:</label>
      <input type="text" id="img-player" placeholder="Enter image URL or player.png"
        value="https://api.iconify.design/lucide:user.svg?color=%233498db" />
    </div>
    <div class="config-group">
      <label for="img-normal">Normal Zombie Image URL:</label>
      <input type="text" id="img-normal" placeholder="Enter image URL or normal.png"
        value="https://api.iconify.design/lucide:ghost.svg?color=%232ecc71" />
    </div>
    <div class="config-group">
      <label for="img-fast">Fast Zombie Image URL:</label>
      <input type="text" id="img-fast" placeholder="Enter image URL or fast.png"
        value="https://api.iconify.design/lucide:zap.svg?color=%23e74c3c" />
    </div>
    <div class="config-group">
      <label for="img-tank">Tank Zombie Image URL:</label>
      <input type="text" id="img-tank" placeholder="Enter image URL or tank.png"
        value="https://api.iconify.design/lucide:shield.svg?color=%239b59b6" />
    </div>
  </div>

  <div class="game-container">
    <canvas id="arena" width="600" height="600"></canvas>

    <div class="sidebar">
      <!-- Player Stats -->
      <div class="card">
        <h3>Character Status</h3>
        <div class="stat-row">
          <span>Health:</span>
          <span id="hp-text">100 / 100</span>
        </div>
        <div class="bar-bg">
          <div id="hp-fill" class="bar-fill"></div>
        </div>

        <div class="stat-row" style="margin-top: 8px;">
          <span>Level <strong id="level-txt">1</strong>:</span>
          <span id="xp-text">0 / 100 XP</span>
        </div>
        <div class="bar-bg">
          <div id="xp-fill" class="bar-fill"></div>
        </div>

        <div class="stat-row" style="margin-top: 10px;">
          <span>Cash:</span>
          <strong id="cash-txt" style="color: #2ecc71;">$0</strong>
        </div>
        <div class="stat-row">
          <span>Active Buffs:</span>
          <span id="buff-txt" style="color: #3498db;">Base Stats</span>
        </div>
      </div>

      <!-- Shop -->
      <div class="card">
        <h3>Upgrades Shop</h3>
        <button class="shop-btn" id="buy-dmg">
          <span>Damage (+5)</span>
          <span id="cost-dmg">$50</span>
        </button>
        <button class="shop-btn" id="buy-firerate">
          <span>Fire Rate (-30ms)</span>
          <span id="cost-firerate">$75</span>
        </button>
        <button class="shop-btn" id="buy-speed">
          <span>Speed (+0.3)</span>
          <span id="cost-speed">$40</span>
        </button>
      </div>

      <!-- Controls Hint -->
      <div class="controls-hint">
        <strong>Controls:</strong> W, A, S, D to Move | Left Click to Shoot
      </div>
    </div>
  </div>

  <script>
    const canvas = document.getElementById('arena');
    const ctx = canvas.getContext('2d');

    // Load Images dynamically
    const images = {
      player: new Image(),
      normal: new Image(),
      fast: new Image(),
      tank: new Image()
    };

    function updateImageSources() {
      images.player.src = document.getElementById('img-player').value;
      images.normal.src = document.getElementById('img-normal').value;
      images.fast.src = document.getElementById('img-fast').value;
      images.tank.src = document.getElementById('img-tank').value;
    }

    ['img-player', 'img-normal', 'img-fast', 'img-tank'].forEach(id => {
      document.getElementById(id).addEventListener('change', updateImageSources);
    });
    updateImageSources();

    // Game State & Stats
    const player = {
      x: canvas.width / 2,
      y: canvas.height / 2,
      radius: 18,
      speed: 3,
      hp: 100,
      maxHp: 100,
      level: 1,
      xp: 0,
      nextXp: 100,
      cash: 0,
      damage: 25,
      fireRate: 300, // ms between shots
      lastShot: 0
    };

    // Upgrade Costs & Levels
    const shop = {
      dmgCost: 50,
      fireRateCost: 75,
      speedCost: 40
    };

    const keys = {};
    const mouse = { x: 0, y: 0, isDown: false };
    const bullets = [];
    const zombies = [];

    // Zombie Definitions
    const ZOMBIE_TYPES = {
      NORMAL: { name: 'normal', speed: 1.5, hp: 50, radius: 16, color: '#2ecc71', rewardCash: 15, rewardXp: 25 },
      FAST: { name: 'fast', speed: 2.8, hp: 25, radius: 12, color: '#e74c3c', rewardCash: 20, rewardXp: 35 },
      TANK: { name: 'tank', speed: 0.8, hp: 160, radius: 24, color: '#9b59b6', rewardCash: 45, rewardXp: 70 }
    };

    // Event Listeners
    window.addEventListener('keydown', e => keys[e.key.toLowerCase()] = true);
    window.addEventListener('keyup', e => keys[e.key.toLowerCase()] = false);

    canvas.addEventListener('mousemove', e => {
      const rect = canvas.getBoundingClientRect();
      mouse.x = e.clientX - rect.left;
      mouse.y = e.clientY - rect.top;
    });

    canvas.addEventListener('mousedown', e => { if (e.button === 0) mouse.isDown = true; });
    canvas.addEventListener('mouseup', e => { if (e.button === 0) mouse.isDown = false; });

    // Shop Purchasing Logic
    document.getElementById('buy-dmg').onclick = () => {
      if (player.cash >= shop.dmgCost) {
        player.cash -= shop.dmgCost;
        player.damage += 5;
        shop.dmgCost = Math.floor(shop.dmgCost * 1.4);
        updateUI();
      }
    };
    document.getElementById('buy-firerate').onclick = () => {
      if (player.cash >= shop.fireRateCost && player.fireRate > 60) {
        player.cash -= shop.fireRateCost;
        player.fireRate -= 30;
        shop.fireRateCost = Math.floor(shop.fireRateCost * 1.5);
        updateUI();
      }
    };
    document.getElementById('buy-speed').onclick = () => {
      if (player.cash >= shop.speedCost) {
        player.cash -= shop.speedCost;
        player.speed += 0.3;
        shop.speedCost = Math.floor(shop.speedCost * 1.3);
        updateUI();
      }
    };

    // Spawn Zombie Logic
    function spawnZombie() {
      if (zombies.length >= 25) return; // Cap maximum zombies

      const rand = Math.random();
      let type = ZOMBIE_TYPES.NORMAL;
      if (rand < 0.3) type = ZOMBIE_TYPES.FAST;
      else if (rand < 0.5) type = ZOMBIE_TYPES.TANK;

      // Spawn on border
      let x, y;
      if (Math.random() < 0.5) {
        x = Math.random() < 0.5 ? 0 : canvas.width;
        y = Math.random() * canvas.height;
      } else {
        x = Math.random() * canvas.width;
        y = Math.random() < 0.5 ? 0 : canvas.height;
      }

      zombies.push({
        x, y,
        type: type.name,
        hp: type.hp + (player.level * 5), // Scaled with level
        maxHp: type.hp + (player.level * 5),
        speed: type.speed,
        radius: type.radius,
        color: type.color,
        rewardCash: type.rewardCash,
        rewardXp: type.rewardXp
      });
    }

    setInterval(spawnZombie, 1200);

    // XP & Level System
    function addXp(amount) {
      player.xp += amount;
      if (player.xp >= player.nextXp) {
        player.xp -= player.nextXp;
        player.level++;
        player.nextXp = Math.floor(player.nextXp * 1.35);

        // Roblox-Style Level Buffs
        player.maxHp += 15;
        player.hp = player.maxHp; // Heal on level up
        player.damage += 3;
        player.speed += 0.1;
      }
      updateUI();
    }

    function updateUI() {
      document.getElementById('hp-text').innerText = `${Math.ceil(player.hp)} / ${player.maxHp}`;
      document.getElementById('hp-fill').style.width = `${Math.max(0, (player.hp / player.maxHp) * 100)}%`;

      document.getElementById('level-txt').innerText = player.level;
      document.getElementById('xp-text').innerText = `${player.xp} / ${player.nextXp} XP`;
      document.getElementById('xp-fill').style.width = `${(player.xp / player.nextXp) * 100}%`;

      document.getElementById('cash-txt').innerText = `$${player.cash}`;
      document.getElementById('buff-txt').innerText = `+${(player.level - 1) * 3} Dmg, +${(player.level - 1) * 15} Max HP`;

      document.getElementById('cost-dmg').innerText = `$${shop.dmgCost}`;
      document.getElementById('cost-firerate').innerText = player.fireRate <= 60 ? 'MAX' : `$${shop.fireRateCost}`;
      document.getElementById('cost-speed').innerText = `$${shop.speedCost}`;

      document.getElementById('buy-dmg').disabled = player.cash < shop.dmgCost;
      document.getElementById('buy-firerate').disabled = player.cash < shop.fireRateCost || player.fireRate <= 60;
      document.getElementById('buy-speed').disabled = player.cash < shop.speedCost;
    }

    // Helper to Draw Characters (Image or Color Fallback)
    function drawEntity(x, y, radius, imgObj, fallbackColor) {
      ctx.save();
      if (imgObj.complete && imgObj.naturalWidth !== 0) {
        ctx.beginPath();
        ctx.arc(x, y, radius, 0, Math.PI * 2);
        ctx.clip();
        ctx.drawImage(imgObj, x - radius, y - radius, radius * 2, radius * 2);
      } else {
        ctx.beginPath();
        ctx.arc(x, y, radius, 0, Math.PI * 2);
        ctx.fillStyle = fallbackColor;
        ctx.fill();
      }
      ctx.restore();
    }

    // Main Game Loop
    function gameLoop(timestamp) {
      // 1. Clear Arena Box
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      // 2. Player Movement
      let dx = 0, dy = 0;
      if (keys['w'] || keys['arrowup']) dy -= 1;
      if (keys['s'] || keys['arrowdown']) dy += 1;
      if (keys['a'] || keys['arrowleft']) dx -= 1;
      if (keys['d'] || keys['arrowright']) dx += 1;

      if (dx !== 0 && dy !== 0) {
        dx *= 0.7071;
        dy *= 0.7071;
      }

      player.x = Math.max(player.radius, Math.min(canvas.width - player.radius, player.x + dx * player.speed));
      player.y = Math.max(player.radius, Math.min(canvas.height - player.radius, player.y + dy * player.speed));

      // 3. Shooting
      if (mouse.isDown && timestamp - player.lastShot >= player.fireRate) {
        const angle = Math.atan2(mouse.y - player.y, mouse.x - player.x);
        bullets.push({
          x: player.x,
          y: player.y,
          vx: Math.cos(angle) * 8,
          vy: Math.sin(angle) * 8
        });
        player.lastShot = timestamp;
      }

      // 4. Update & Draw Bullets
      for (let i = bullets.length - 1; i >= 0; i--) {
        const b = bullets[i];
        b.x += b.vx;
        b.y += b.vy;

        ctx.beginPath();
        ctx.arc(b.x, b.y, 4, 0, Math.PI * 2);
        ctx.fillStyle = '#f1c40f';
        ctx.fill();

        // Remove out-of-bounds bullets
        if (b.x < 0 || b.x > canvas.width || b.y < 0 || b.y > canvas.height) {
          bullets.splice(i, 1);
        }
      }

      // 5. Update & Draw Zombies
      for (let i = zombies.length - 1; i >= 0; i--) {
        const z = zombies[i];

        // Move towards player
        const angle = Math.atan2(player.y - z.y, player.x - z.x);
        z.x += Math.cos(angle) * z.speed;
        z.y += Math.sin(angle) * z.speed;

        // Draw Zombie Image/Shape
        drawEntity(z.x, z.y, z.radius, images[z.type], z.color);

        // Draw Zombie Health Bar
        ctx.fillStyle = '#444';
        ctx.fillRect(z.x - 15, z.y - z.radius - 8, 30, 4);
        ctx.fillStyle = '#e74c3c';
        ctx.fillRect(z.x - 15, z.y - z.radius - 8, (z.hp / z.maxHp) * 30, 4);

        // Bullet Collisions
        for (let j = bullets.length - 1; j >= 0; j--) {
          const b = bullets[j];
          const dist = Math.hypot(b.x - z.x, b.y - z.y);
          if (dist < z.radius + 4) {
            z.hp -= player.damage;
            bullets.splice(j, 1);
            if (z.hp <= 0) break;
          }
        }

        // Check Zombie Death
        if (z.hp <= 0) {
          player.cash += z.rewardCash;
          addXp(z.rewardXp);
          zombies.splice(i, 1);
          continue;
        }

        // Player Collision / Damage
        const pDist = Math.hypot(player.x - z.x, player.y - z.y);
        if (pDist < player.radius + z.radius) {
          player.hp -= 0.4;
          updateUI();
          if (player.hp <= 0) {
            alert(`GAME OVER!\nYou reached Level ${player.level} with $${player.cash}.`);
            // Reset Game
            player.hp = 100;
            player.maxHp = 100;
            player.level = 1;
            player.xp = 0;
            player.cash = 0;
            player.damage = 25;
            player.speed = 3;
            player.fireRate = 300;
            zombies.length = 0;
            bullets.length = 0;
            updateUI();
          }
        }
      }

      // 6. Draw Player
      drawEntity(player.x, player.y, player.radius, images.player, '#3498db');

      // 7. Draw Aiming Line
      ctx.beginPath();
      ctx.moveTo(player.x, player.y);
      ctx.lineTo(mouse.x, mouse.y);
      ctx.strokeStyle = 'rgba(255, 255, 255, 0.15)';
      ctx.lineWidth = 1;
      ctx.stroke();

      requestAnimationFrame(gameLoop);
    }

    // Start Game Loop
    updateUI();
    requestAnimationFrame(gameLoop);
  </script>
</body>

</html>