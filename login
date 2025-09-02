<html lang="th">
<head>
  <meta charset="UTF-8">
  <title>ระบบรหัสโครงการ</title>
  <link href="https://fonts.googleapis.com/css2?family=Kanit:wght@300;400;600&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    body { font-family: 'Kanit', sans-serif; }
    .card { background: white; border-radius: 1rem; box-shadow: 0 4px 12px rgba(0,0,0,0.1); padding: 1.5rem; }
  </style>
</head>
<body class="bg-gradient-to-r from-blue-50 to-indigo-100 min-h-screen flex items-center justify-center">

  <!-- Login Page -->
  <div id="loginPage" class="card w-full max-w-md">
    <h2 class="text-2xl font-semibold text-center mb-4">เข้าสู่ระบบ</h2>

    <div class="mb-3">
      <label class="block mb-1">OrgCode</label>
      <select id="orgCode" class="w-full border p-2 rounded">
        <option value="A01">A01</option>
        <option value="B01">B01</option>
        <option value="E01">E01</option>
        <option value="G01">G01</option>
        <option value="G02">G02</option>
        <option value="G03">G03</option>
        <option value="G04">G04</option>
        <option value="G05">G05</option>
        <option value="G06">G06</option>
      </select>
    </div>

    <div class="mb-3">
      <label class="block mb-1">SubLevel</label>
      <select id="subLevel" class="w-full border p-2 rounded">
        <option value="001">001</option>
        <option value="002">002</option>
        <option value="003">003</option>
        <option value="004">004</option>
        <option value="011">011</option>
      </select>
    </div>

    <div class="mb-3">
      <label class="block mb-1">Password</label>
      <input type="password" id="password" class="w-full border p-2 rounded" placeholder="กรอกรหัสผ่าน">
    </div>

    <button onclick="login()" class="w-full bg-blue-600 text-white p-2 rounded hover:bg-blue-700">เข้าสู่ระบบ</button>
  </div>

  <!-- Project Page -->
  <div id="projectPage" class="hidden card w-full max-w-3xl">
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-2xl font-semibold">สร้างรหัสโครงการ</h2>
      <button onclick="logout()" class="text-red-600 hover:underline">ออกจากระบบ</button>
    </div>

    <p class="mb-4 text-gray-600">ยินดีต้อนรับ: <span id="displayUser"></span></p>

    <!-- Section 1 -->
    <div class="mb-4 border-l-4 border-blue-500 pl-3 bg-blue-50 rounded">
      <h3 class="font-semibold mb-2">ส่วนที่ 1: ข้อมูลหน่วยงาน</h3>
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label>ปีงบประมาณ</label>
          <select id="year" class="w-full border p-2 rounded">
            <option value="68">2568</option>
            <option value="69">2569</option>
          </select>
        </div>
        <div>
          <label>สังกัด (OrgCode)</label>
          <input type="text" id="orgCodeFixed" class="w-full border p-2 rounded bg-gray-100" readonly>
        </div>
      </div>
    </div>

    <!-- Section 2 -->
    <div class="mb-4 border-l-4 border-green-500 pl-3 bg-green-50 rounded">
      <h3 class="font-semibold mb-2">ส่วนที่ 2: ข้อมูลโครงการ</h3>
      <div class="mb-2">
        <label>ชื่อโครงการ</label>
        <input type="text" id="projectName" class="w-full border p-2 rounded">
      </div>
      <div class="grid grid-cols-3 gap-4">
        <div>
          <label>แหล่งงบประมาณ</label>
          <select id="budget" class="w-full border p-2 rounded">
            <option value="B">งบประมาณ (B)</option>
            <option value="N">นอกงบประมาณ (N)</option>
          </select>
        </div>
        <div>
          <label>Project Type</label>
          <select id="ptype" class="w-full border p-2 rounded">
            <option value="N">N - โครงการใหม่</option>
            <option value="C">C - ต่อเนื่อง</option>
            <option value="R">R - ปรับแผน</option>
          </select>
        </div>
        <div>
          <label>สถานะ</label>
          <select id="status" class="w-full border p-2 rounded">
            <option>Planning</option>
            <option>Completed</option>
            <option>Canceled</option>
            <option>Active</option>
            <option>Suspended</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Section 3 -->
    <div class="mb-4 border-l-4 border-purple-500 pl-3 bg-purple-50 rounded">
      <h3 class="font-semibold mb-2">ส่วนที่ 3: รหัสโครงการ</h3>
      <button onclick="generateCode()" class="bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700">สร้างรหัส</button>
      <p class="mt-2 text-lg font-semibold text-purple-700">รหัสโครงการ: <span id="finalCode">-</span></p>
    </div>
  </div>

  <script>
    function login() {
      const org = document.getElementById("orgCode").value;
      const sub = document.getElementById("subLevel").value;
      const pass = document.getElementById("password").value;

      const username = org + "-" + sub;
      const expectedPassword = org + sub; // ตัวอย่าง: A01 + 011 = A01011

      if (pass !== expectedPassword) {
        alert("รหัสผ่านไม่ถูกต้อง!");
        return;
      }

      localStorage.setItem("userData", JSON.stringify({ username, org, sub }));

      loadProjectPage(username, org, sub);
    }

    function loadProjectPage(username, org, sub) {
      document.getElementById("loginPage").classList.add("hidden");
      document.getElementById("projectPage").classList.remove("hidden");

      document.getElementById("displayUser").textContent = username;
      document.getElementById("orgCodeFixed").value = org;
    }

    function logout() {
      localStorage.removeItem("userData");
      document.getElementById("projectPage").classList.add("hidden");
      document.getElementById("loginPage").classList.remove("hidden");
    }

    function generateCode() {
      const year = document.getElementById("year").value;
      const org = document.getElementById("orgCodeFixed").value;
      const sub = JSON.parse(localStorage.getItem("userData")).sub || "000";
      const budget = document.getElementById("budget").value;
      const ptype = document.getElementById("ptype").value;
      const status = document.getElementById("status").value;

      const running = Math.floor(Math.random() * 900 + 100); // mock
      const code = `${year}-${org}${sub}-${budget}${running}[${ptype}] (${status})`;

      document.getElementById("finalCode").textContent = code;
    }

    window.onload = () => {
      const saved = localStorage.getItem("userData");
      if(saved) {
        const { username, org, sub } = JSON.parse(saved);
        loadProjectPage(username, org, sub);
      }
    };
  </script>
</body>
</html>
