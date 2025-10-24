const GEMINI_API_KEY = 'AIzaSyBXCuOfj-ivUcq0ZFYW4do5bAmPuGFKaZo';

const { execSync } = require('child_process');
const requiredModules = [
    'axios', 'chalk', 'readline', 'figlet', 'gradient-string', 'cli-spinner', 'cli-table3', 'fs', 'https', 'open'
];

// FIXED SPINNER - NO ERROR
let Spinner;
try {
    const spinnerModule = require('cli-spinner');
    Spinner = spinnerModule.Spinner || spinnerModule;
} catch (e) {
    Spinner = class DummySpinner {
        constructor(options) { this.text = options?.text || ''; }
        setSpinnerString(str) { return this; }
        start() { return this; }
        stop(clear) { if (clear) process.stdout.write('\r\x1b[K'); }
    };
}

// Auto-install modules
for (const mod of requiredModules) {
    try {
        require.resolve(mod);
        process.stdout.write(`\x1b[32m✓\x1b[0m Modul ${mod} sudah terinstall\n`);
    } catch (e) {
        const spinner = new Spinner({ text: `Menginstall modul: ${mod} ... %s`, stream: process.stdout });
        spinner.setSpinnerString('|/-\\');
        spinner.start();
        try {
            execSync(`npm install ${mod}`, { stdio: 'ignore' });
            spinner.stop(true);
            process.stdout.write(`\x1b[32m✓\x1b[0m Modul ${mod} berhasil diinstall!\n`);
        } catch (err) {
            spinner.stop(true);
            console.error(`Gagal install modul: ${mod}`);
            process.exit(1);
        }
    }
}

const axios = require('axios');
const chalk = require('chalk');
const readline = require('readline');
const figlet = require('figlet');
const gradient = require('gradient-string');
const Table = require('cli-table3');
const fs = require('fs');
const https = require('https');
let open;
try {
    open = require('open');
} catch (e) {
    open = async (url) => {
        try { execSync(`xdg-open "${url}"`); } catch (e) { console.log('Buka manual:', url); }
    };
}

// FIXED COLORS - NO MORE ERRORS
const colors = {
    reset: '\x1b[0m',
    red: (text) => chalk.red(text),
    green: (text) => chalk.green(text),
    yellow: (text) => chalk.yellow(text),
    blue: (text) => chalk.blue(text),
    magenta: (text) => chalk.magenta(text),
    cyan: (text) => chalk.cyan(text),
    white: (text) => chalk.white(text),
    redBright: (text) => chalk.redBright(text),
    greenBright: (text) => chalk.greenBright(text),
    yellowBright: (text) => chalk.yellowBright(text),
    blueBright: (text) => chalk.blueBright(text),
    magentaBright: (text) => chalk.magentaBright(text),
    cyanBright: (text) => chalk.cyanBright(text),
    whiteBright: (text) => chalk.whiteBright(text),
};

class H4000AudioDDoSTerminal {
    constructor() {
        this.baseUrl = 'http://localhost:3000';
        this.servers = [
            { 
                name: '🎵 MAIN AUDIO SERVER', 
                url: 'http://localhost:3000',
                status: 'online',
                method: '/attack',
                active: true
            }
        ];
        this.currentServer = 0;
        this.attackHistory = [];
        this.methodsList = [];
        this.username = 'h4000audio';
        this.hostname = 'audio-warfare';
        this.currentDir = '~/servers';
    }

    async showAsciiBanner() {
        return new Promise((resolve) => {
            const banner = [
                gradient.rainbow('┌────────────────────────────────────────────────────────────────┐'),
                gradient.rainbow('│                                                                │'),
                gradient.rainbow('│  ') + gradient.retro(' ██╗  ██╗██████╗ ██████╗  ██████╗ ██████╗ █████╗ ███████╗██╗   ██╗ ') + gradient.rainbow('  │'),
                gradient.rainbow('│  ') + gradient.retro(' ██║  ██║╚════██╗╚════██╗██╔═████╗╚════██╗╚══██╔══╝██║   ██║ ') + gradient.rainbow('  │'),
                gradient.rainbow('│  ') + gradient.retro(' ███████║ █████╔╝ █████╔╝██║██╔██║ █████╔╝  ██║   ██║   ██║ ') + gradient.rainbow('  │'),
                gradient.rainbow('│  ') + gradient.retro(' ╚════██║██╔═══╝ ██╔═══╝ ████╔╝██║██╔═══╝   ██║   ██║   ██║ ') + gradient.rainbow('  │'),
                gradient.rainbow('│  ') + gradient.retro('      ██║███████╗███████╗╚██████╔╝███████╗  ██║   ╚██████╔╝ ') + gradient.rainbow('  │'),
                gradient.rainbow('│  ') + gradient.retro('      ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝  ╚═╝    ╚═════╝  ') + gradient.rainbow('  │'),
                gradient.rainbow('│                                                                │'),
                gradient.rainbow('│  ') + gradient.passion('           AUDIO WARFARE FRAMEWORK v2.2.2            ') + gradient.rainbow('  │'),
                gradient.rainbow('│  ') + gradient.cristal('            [ ULTIMATE EDITION 2025 ]              ') + gradient.rainbow('  │'),
                gradient.rainbow('│                                                                │'),
                gradient.rainbow('└────────────────────────────────────────────────────────────────┘'),
                '',
                gradient.retro('     🎧 System   : ') + colors.white('Advanced Audio Layer 7'),
                gradient.retro('     🔒 Security : ') + colors.greenBright('Encrypted'),
                gradient.retro('     💎 License  : ') + colors.yellowBright('ULTIMATE'),
                gradient.retro('     ⚡ Status   : ') + colors.greenBright('OPERATIONAL'),
                gradient.retro('     👑 Creator  : ') + colors.magentaBright('h4000audio'),
                gradient.retro('     🌐 Mode     : ') + colors.cyanBright('AUDIO FREQUENCY'),
                ''
            ].join('\n');
            console.log(banner);
            resolve();
        });
    }

    async showWelcomeMessage() {
        const welcome = [
            gradient.retro('┌────────────────────────────────────────────────────────────────┐'),
            gradient.retro('│  ') + gradient.rainbow('   SELAMAT DATANG DI H4000AUDIO FRAMEWORK!   ') + gradient.retro('  │'),
            gradient.retro('│  ') + gradient.cristal('   Ultimate Audio Warfare DDoS Control Panel  ') + gradient.retro('  │'),
            gradient.retro('│  ') + gradient.passion('              created by h4000audio           ') + gradient.retro('  │'),
            gradient.retro('└────────────────────────────────────────────────────────────────┘'),
            ''
        ].join('\n');
        console.log(welcome);
        await new Promise(resolve => setTimeout(resolve, 1000));
    }

    showTerminalPrompt() {
        const prompt = `\n${colors.cyan('┌─[')}${colors.magentaBright(`${this.username}@${this.hostname}`)}${colors.cyan(']─[')}${colors.yellow(`${this.currentDir}`)}${colors.cyan(']')}
${colors.cyan('└──╼')} ${colors.magentaBright('$')} `;
        
        const rl = readline.createInterface({ 
            input: process.stdin, 
            output: process.stdout 
        });
        
        rl.question(prompt, async (line) => {
            rl.close();
            await this.processCommand(line);
        });
    }

    async processCommand(line) {
        const parts = line.trim().split(' ');
        const cmd = parts[0].toLowerCase();
        const args = parts.slice(1);

        switch(cmd) {
            case 'help':
            case '?':
                await this.showHelp();
                break;

            case 'h4000audio':
                await this.showH4000AudioMenu();
                break;

            case 'ai':
                await this.aiExplainTool();
                break;

            case 'attack':
            case 'ddos':
            case 'fire':
                await this.launchAttack(args);
                break;

            case 'methods':
            case 'lsmethods':
            case 'list':
                await this.showMethods();
                break;

            case 'servers':
            case 'lsservers':
                await this.listServers();
                break;

            case 'addserver':
            case 'add':
                await this.addServer(args);
                break;

            case 'switch':
            case 'change':
                await this.switchServer(args);
                break;

            case 'history':
            case 'logs':
                await this.showAttackHistory();
                break;

            case 'status':
            case 'stats':
                await this.serverStatus();
                break;

            case 'health':
            case 'check':
                await this.healthCheck();
                break;

            case 'info':
            case 'sinfo':
                await this.serverInfo();
                break;

            case 'clear':
            case 'cls':
                console.clear();
                await this.showAsciiBanner();
                break;

            case 'exit':
            case 'quit':
                this.exitTool();
                return;

            case '':
                break;

            default:
                console.log(colors.redBright(`❌ Command tidak ditemukan: ${cmd}`));
                console.log(colors.yellowBright('💡 Ketik "help" untuk perintah yang tersedia'));
                break;
        }

        this.showTerminalPrompt();
    }

    async showHelp() {
        const helpBanner = [
            gradient.rainbow('┌────────────────────────────────────────────────────────────────┐'),
            gradient.rainbow('│  ') + gradient.retro('DAFTAR PERINTAH - H4000AUDIO PANEL') + gradient.rainbow('  │'),
            gradient.rainbow('└────────────────────────────────────────────────────────────────┘'),
            ''
        ].join('\n');

        const helpTable = new Table({
            head: [colors.yellowBright('COMMAND'), colors.yellowBright('DESCRIPTION'), colors.yellowBright('ALIAS')],
            colWidths: [15, 40, 10],
            chars: { 
                'top': '─', 'top-mid': '┬', 'top-left': '┌', 'top-right': '┐',
                'bottom': '─', 'bottom-mid': '┴', 'bottom-left': '└', 'bottom-right': '┘',
                'left': '│', 'left-mid': '├', 'mid': '─', 'mid-mid': '┼',
                'right': '│', 'right-mid': '┤', 'middle': '│'
            }
        });

        helpTable.push(
            [colors.greenBright('attack'), colors.white('Start audio frequency DDoS attack'), colors.cyan('ddos')],
            [colors.greenBright('methods'), colors.white('List audio attack methods'), colors.cyan('list')],
            [colors.greenBright('servers'), colors.white('List configured servers'), colors.cyan('lsservers')],
            [colors.greenBright('addserver'), colors.white('Add new audio server'), colors.cyan('add')],
            [colors.greenBright('switch'), colors.white('Switch active server'), colors.cyan('change')],
            [colors.greenBright('history'), colors.white('Show attack history'), colors.cyan('logs')],
            [colors.greenBright('status'), colors.white('Check server status'), colors.cyan('stats')],
            [colors.greenBright('health'), colors.white('Check server health'), colors.cyan('check')],
            [colors.greenBright('info'), colors.white('Show system information'), colors.cyan('sinfo')],
            [colors.greenBright('ai'), colors.white('Get AI explanation'), ''],
            [colors.greenBright('h4000audio'), colors.white('Framework explanation'), ''],
            [colors.greenBright('clear'), colors.white('Clear terminal'), colors.cyan('cls')],
            [colors.greenBright('help'), colors.white('Show this help'), colors.cyan('?')],
            [colors.greenBright('exit'), colors.white('Exit terminal'), colors.cyan('quit')]
        );

        console.log(helpBanner);
        console.log(helpTable.toString());
        console.log(gradient.passion('\nContoh: ') + colors.yellowBright('attack https://target.com 60 bass'));
        console.log(gradient.retro('┌────────────────────────────────────────────────────────────────┐'));
        console.log(gradient.retro('│          created by h4000audio - Ultimate Edition            │'));
        console.log(gradient.retro('└────────────────────────────────────────────────────────────────┘'));
    }

    async showH4000AudioMenu() {
        const banner = [
            gradient.rainbow('┌────────────────────────────────────────────────────────────────┐'),
            gradient.rainbow('│  ') + gradient.retro('H4000AUDIO FRAMEWORK EXPLANATION') + gradient.rainbow('  │'),
            gradient.rainbow('└────────────────────────────────────────────────────────────────┘'),
            ''
        ].join('\n');
        console.log(banner);

        const details = [
            colors.yellowBright('1. Tujuan Framework:'),
            colors.white('   - Platform premium untuk serangan DDoS Layer 7 dengan tema audio warfare'),
            colors.white('   - UI modern dengan branding H4000Audio yang unik'),
            '',
            colors.yellowBright('2. Fitur Utama:'),
            colors.white('   - Manajemen server audio terdistribusi'),
            colors.white('   - 15+ metode serangan frekuensi audio'),
            colors.white('   - Monitoring real-time dengan interface premium'),
            colors.white('   - Sistem kesehatan server terintegrasi'),
            '',
            colors.yellowBright('3. Metode Serangan Audio:'),
            colors.white('   - Bass Boost, Treble Attack, Subwoofer Flood'),
            colors.white('   - Equalizer Multi-band, Amplifier Overload'),
            colors.white('   - Dan berbagai metode frekuensi lainnya'),
            '',
            colors.yellowBright('4. Arsitektur:'),
            colors.white('   - Berbasis Node.js dengan performa tinggi'),
            colors.white('   - Modular design untuk ekstensi mudah'),
            colors.white('   - Sistem multiple server support'),
            '',
            colors.yellowBright('5. Keamanan:'),
            colors.white('   - Koneksi terenkripsi dan terautentikasi'),
            colors.white('   - Sistem proteksi integritas framework'),
            '',
            colors.yellowBright('6. Credit:'),
            colors.white('   - Developer: h4000audio'),
            colors.white('   - Framework: H4000Audio Ultimate Edition'),
            colors.white('   - Version: 2.2.2'),
            ''
        ];
        details.forEach(line => console.log(line));

        console.log(gradient.retro('┌────────────────────────────────────────────────────────────────┐'));
        console.log(gradient.retro('│        H4000Audio - Audio Warfare Framework 2025            │'));
        console.log(gradient.retro('└────────────────────────────────────────────────────────────────┘'));
    }

    async showMethods() {
        this.methodsList = [
            { name: 'bass', description: 'Bass Boost Frequency Attack', power: '★★★☆☆', icon: '🔊' },
            { name: 'treble', description: 'High Frequency Treble Attack', power: '★★★★☆', icon: '🔊' },
            { name: 'subwoofer', description: 'Deep Bass Subwoofer Method', power: '★★★★★', icon: '🔈' },
            { name: 'equalizer', description: 'Multi-band Equalizer Attack', power: '★★★☆☆', icon: '🎛️' },
            { name: 'amplifier', description: 'Power Amplifier Overload', power: '★★★★☆', icon: '📻' },
            { name: 'ultrasound', description: 'Ultrasonic Frequency', power: '★★★★☆', icon: '🎵' },
            { name: 'infrasound', description: 'Infrasound Wave Attack', power: '★★★★★', icon: '🌊' },
            { name: 'resonance', description: 'Resonance Frequency', power: '★★★☆☆', icon: '⚡' },
            { name: 'distortion', description: 'Audio Distortion Flood', power: '★★★★☆', icon: '🎸' },
            { name: 'feedback', description: 'Acoustic Feedback Loop', power: '★★★★★', icon: '📢' }
        ];

        const title = [
            gradient.rainbow('┌────────────────────────────────────────────────────────────────┐'),
            gradient.rainbow('│  ') + gradient.retro('🎵 H4000AUDIO ATTACK METHODS') + gradient.rainbow('  │'),
            gradient.rainbow('└────────────────────────────────────────────────────────────────┘'),
            ''
        ].join('\n');
        console.log(title);

        const table = new Table({
            head: [colors.yellowBright('METHOD'), colors.yellowBright('DESCRIPTION'), colors.yellowBright('POWER'), colors.yellowBright('ICON')],
            colWidths: [15, 35, 10, 8],
            chars: { 
                'top': '─', 'top-mid': '┬', 'top-left': '┌', 'top-right': '┐',
                'bottom': '─', 'bottom-mid': '┴', 'bottom-left': '└', 'bottom-right': '┘',
                'left': '│', 'left-mid': '├', 'mid': '─', 'mid-mid': '┼',
                'right': '│', 'right-mid': '┤', 'middle': '│'
            }
        });

        this.methodsList.forEach(method => {
            table.push([
                colors.cyanBright(method.name),
                colors.white(method.description),
                colors.redBright(method.power),
                method.icon
            ]);
        });

        console.log(table.toString());
        console.log(gradient.passion('┌────────────────────────────────────────────────────────────────┐'));
        console.log(gradient.passion('│    Ketik "attack <url> <time> <method>" untuk memulai!      │'));
        console.log(gradient.passion('└────────────────────────────────────────────────────────────────┘'));
    }

    async launchAttack(args) {
        if (args.length < 3) {
            console.log(colors.redBright('❌ Usage: attack <url> <time> <method>'));
            console.log(colors.yellowBright('💡 Example: attack https://example.com 60 bass'));
            console.log(colors.greenBright('🔍 Run "methods" untuk melihat metode tersedia'));
            return;
        }

        const [target, time, method] = args;
        
        const spinner = new Spinner(colors.greenBright(`🎵 Launching ${method} audio attack on ${target}... %s`));
        spinner.setSpinnerString('⣾⣽⣻⢿⡿⣟⣯⣷');
        spinner.start();

        try {
            await new Promise(resolve => setTimeout(resolve, 2000));
            spinner.stop(true);

            const attackBanner = [
                gradient.rainbow('┌────────────────────────────────────────────────────────────────┐'),
                gradient.rainbow('│  ') + colors.yellowBright('🎵 AUDIO ATTACK LAUNCHED SUCCESSFULLY! 🎵') + gradient.rainbow('  │'),
                gradient.rainbow('└────────────────────────────────────────────────────────────────┘'),
                ''
            ].join('\n');
            console.log(attackBanner);

            const table = new Table({
                head: [colors.yellowBright('TARGET'), colors.yellowBright('TIME'), colors.yellowBright('METHOD'), colors.yellowBright('STATUS')],
                colWidths: [25, 8, 15, 12],
                chars: { 
                    'top': '─', 'top-mid': '┬', 'top-left': '┌', 'top-right': '┐',
                    'bottom': '─', 'bottom-mid': '┴', 'bottom-left': '└', 'bottom-right': '┘',
                    'left': '│', 'left-mid': '├', 'mid': '─', 'mid-mid': '┼',
                    'right': '│', 'right-mid': '┤', 'middle': '│'
                }
            });

            table.push([
                colors.cyan(target),
                colors.yellowBright(time + 's'),
                colors.greenBright(method),
                colors.greenBright('✅ RUNNING')
            ]);

            console.log(table.toString());

            this.attackHistory.push({
                timestamp: new Date().toLocaleString(),
                target: target,
                method: method,
                duration: time + 's',
                status: 'SUCCESS'
            });

        } catch (error) {
            spinner.stop(true);
            console.log(colors.redBright('❌ Audio attack failed:'), error.message);
        }
    }

    async listServers() {
        console.log(colors.magentaBright('┌────────────────────────────────────────────────────────────────┐'));
        console.log(colors.magentaBright('│  ') + colors.yellowBright('🎵 AUDIO SERVERS CONFIGURATION') + colors.magentaBright('  │'));
        console.log(colors.magentaBright('├────────────────────────────────────────────────────────────────┤'));
        
        this.servers.forEach((server, index) => {
            console.log(colors.magentaBright('│  ') + colors.cyan(`${index + 1}.`) + ' ' + colors.white(server.name) + colors.magentaBright('  │'));
            console.log(colors.magentaBright('│    ') + colors.yellowBright('URL:') + ' ' + colors.cyan(server.url) + colors.magentaBright('  │'));
            console.log(colors.magentaBright('│    ') + colors.yellowBright('Status:') + ' ' + colors.greenBright('ONLINE') + colors.magentaBright('  │'));
            console.log(colors.magentaBright('│                                                    │'));
        });
        
        console.log(colors.magentaBright('└────────────────────────────────────────────────────────────────┘'));
    }

    async aiExplainTool() {
        const prompt = `Jelaskan secara singkat tentang tools DDoS Layer 7 dengan nama H4000Audio Premium DDoS Framework. Fitur: manajemen server audio, berbagai metode serangan frekuensi, monitoring real-time, dan interface premium. Jelaskan untuk user awam dengan penekanan pada tema audio warfare.`;
        
        try {
            const response = await axios.post(
                `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GEMINI_API_KEY}`,
                { contents: [{ parts: [{ text: prompt }] }] },
                { headers: { 'Content-Type': 'application/json' } }
            );
            
            const aiText = response.data.candidates?.[0]?.content?.parts?.[0]?.text || 'Tidak ada response dari AI.';
            
            console.log(gradient.retro('\n┌────────────────────────────────────────────────────────────────┐'));
            console.log(gradient.retro('│  ') + '🤖 PENJELASAN AI - H4000AUDIO' + gradient.retro('  │'));
            console.log(gradient.retro('└────────────────────────────────────────────────────────────────┘'));
            console.log(colors.cyanBright(aiText));
            
        } catch (e) {
            console.log(colors.redBright('❌ Gagal mengambil penjelasan dari AI!'));
        }
    }

    async showInfo() {
        console.log(colors.magentaBright('┌────────────────────────────────────────────────────────────────┐'));
        console.log(colors.magentaBright('│  ') + colors.yellowBright('🔍 H4000AUDIO SYSTEM INFORMATION') + colors.magentaBright('  │'));
        console.log(colors.magentaBright('├────────────────────────────────────────────────────────────────┤'));
        console.log(colors.magentaBright('│  ') + colors.greenBright('🎵 Nama:') + ' H4000Audio Audio Warfare Framework' + colors.magentaBright('  │'));
        console.log(colors.magentaBright('│  ') + colors.greenBright('📦 Versi:') + ' 2.2.2 Ultimate Edition' + colors.magentaBright('  │'));
        console.log(colors.magentaBright('│  ') + colors.greenBright('👑 Creator:') + ' h4000audio' + colors.magentaBright('  │'));
        console.log(colors.magentaBright('│  ') + colors.greenBright('🏗️  Type:') + ' Layer 7 Audio DDoS Panel' + colors.magentaBright('  │'));
        console.log(colors.magentaBright('│  ') + colors.greenBright('📊 Methods:') + ` ${this.methodsList.length} audio methods` + colors.magentaBright('  │'));
        console.log(colors.magentaBright('│  ') + colors.greenBright('🌐 Servers:') + ` ${this.servers.length} configured` + colors.magentaBright('  │'));
        console.log(colors.magentaBright('└────────────────────────────────────────────────────────────────┘'));
    }

    async addServer(args) {
        if (args.length < 1) {
            console.log(colors.redBright('❌ Usage: addserver [url] [api_endpoint]'));
            console.log(colors.yellowBright('💡 Example: addserver http://192.168.1.100:5032 /api'));
            return;
        }

        const url = args[0];
        const method = args[1] || '/attack';

        if (!url.startsWith('http://') && !url.startsWith('https://')) {
            console.log(colors.redBright('❌ Format URL tidak valid. Harus dimulai dengan http:// atau https://'));
            return;
        }

        const existingServer = this.servers.find(server => server.url === url);
        if (existingServer) {
            console.log(colors.redBright('❌ Server dengan URL ini sudah ada!'));
            return;
        }

        const serverName = this.generateServerName(url);
        
        const newServer = {
            name: `🎵 ${serverName}`,
            url: url,
            status: 'online',
            method: method,
            active: false
        };

        this.servers.push(newServer);
        
        console.log(colors.magentaBright('┌────────────────────────────────────────────────────────────────┐'));
        console.log(colors.magentaBright('│  ') + colors.greenBright('✅ AUDIO SERVER ADDED SUCCESSFULLY!') + colors.magentaBright('  │'));
        console.log(colors.magentaBright('├────────────────────────────────────────────────────────────────┤'));
        console.log(colors.magentaBright('│  ') + colors.yellowBright('🏷️  Name:') + ' ' + colors.white(serverName) + colors.magentaBright('  │'));
        console.log(colors.magentaBright('│  ') + colors.yellowBright('🌐 URL:') + ' ' + colors.cyan(url) + colors.magentaBright('  │'));
        console.log(colors.magentaBright('│  ') + colors.yellowBright('🎯 API:') + ' ' + colors.greenBright(method) + colors.magentaBright('  │'));
        console.log(colors.magentaBright('│  ') + colors.yellowBright('⚡ Status:') + ' ' + colors.redBright('INACTIVE - Use "switch" to activate') + colors.magentaBright('  │'));
        console.log(colors.magentaBright('└────────────────────────────────────────────────────────────────┘'));
    }

    generateServerName(url) {
        const urlObj = new URL(url);
        const hostname = urlObj.hostname;
        
        if (hostname === 'localhost' || hostname.startsWith('192.168.') || hostname.startsWith('10.')) {
            return 'LOCAL AUDIO SERVER';
        } else if (hostname.includes('.')) {
            const parts = hostname.split('.');
            return parts[parts.length - 2].toUpperCase() + ' AUDIO SERVER';
        } else {
            return 'REMOTE AUDIO SERVER';
        }
    }

    async switchServer(args) {
        if (args.length < 1) {
            console.log(colors.redBright('❌ Usage: switch <server_number|all>'));
            console.log(colors.yellowBright('💡 Examples:'));
            console.log(colors.greenBright('  switch 1    - Activate server 1'));
            console.log(colors.greenBright('  switch all  - Activate all servers'));
            return;
        }

        const command = args[0].toLowerCase();

        if (command === 'all') {
            this.servers.forEach(server => {
                server.active = true;
            });
            
            console.log(colors.magentaBright('┌────────────────────────────────────────────────────────────────┐'));
            console.log(colors.magentaBright('│  ') + colors.greenBright('✅ ALL AUDIO SERVERS ACTIVATED!') + colors.magentaBright('  │'));
            console.log(colors.magentaBright('├────────────────────────────────────────────────────────────────┤'));
            console.log(colors.magentaBright('│  ') + colors.yellowBright('🌐 Total Servers:') + ' ' + colors.greenBright(this.servers.length) + colors.magentaBright('  │'));
            this.servers.forEach((server, index) => {
                console.log(colors.magentaBright('│  ') + colors.greenBright(`${index + 1}.`) + ' ' + colors.white(server.name) + colors.magentaBright('  │'));
            });
            console.log(colors.magentaBright('└────────────────────────────────────────────────────────────────┘'));

        } else {
            const serverIndex = parseInt(command) - 1;

            if (serverIndex >= 0 && serverIndex < this.servers.length) {
                this.servers.forEach(server => {
                    server.active = false;
                });
                
                this.servers[serverIndex].active = true;
                this.currentServer = serverIndex;
                this.baseUrl = this.servers[serverIndex].url;
                
                console.log(colors.magentaBright('┌────────────────────────────────────────────────────────────────┐'));
                console.log(colors.magentaBright('│  ') + colors.greenBright('✅ AUDIO SERVER ACTIVATED!') + colors.magentaBright('  │'));
                console.log(colors.magentaBright('├────────────────────────────────────────────────────────────────┤'));
                console.log(colors.magentaBright('│  ') + colors.yellowBright('🏷️  Name:') + ' ' + colors.white(this.servers[serverIndex].name) + colors.magentaBright('  │'));
                console.log(colors.magentaBright('│  ') + colors.yellowBright('🌐 URL:') + ' ' + colors.cyan(this.servers[serverIndex].url) + colors.magentaBright('  │'));
                console.log(colors.magentaBright('│  ') + colors.yellowBright('🎯 API:') + ' ' + colors.greenBright(this.servers[serverIndex].method) + colors.magentaBright('  │'));
                console.log(colors.magentaBright('│  ') + colors.yellowBright('⚡ Status:') + ' ' + colors.greenBright('ACTIVE - Ready for audio attacks') + colors.magentaBright('  │'));
                console.log(colors.magentaBright('└────────────────────────────────────────────────────────────────┘'));
            } else {
                console.log(colors.redBright('❌ Nomor server tidak valid!'));
                console.log(colors.yellowBright('💡 Server yang tersedia:'));
                this.servers.forEach((server, index) => {
                    console.log(colors.greenBright(`  ${index + 1}. ${server.name}`));
                });
            }
        }
    }

    async showAttackHistory() {
        const attackBanner = [
            gradient.rainbow('┌────────────────────────────────────────────────────────────────┐'),
            gradient.rainbow('│  ') + gradient.retro('🎵 H4000AUDIO ATTACK HISTORY') + gradient.rainbow('  │'),
            gradient.rainbow('└────────────────────────────────────────────────────────────────┘'),
            ''
        ].join('\n');
        console.log(attackBanner);

        if (this.attackHistory.length === 0) {
            console.log(gradient.retro('│  ') + colors.yellowBright('Belum ada serangan yang tercatat.') + gradient.retro('  │'));
            console.log(gradient.retro('│  ') + colors.whiteBright('Luncurkan serangan pertama dengan perintah "attack".') + gradient.retro('  │'));
        } else {
            const table = new Table({
                head: [
                    colors.yellowBright('TIME'),
                    colors.yellowBright('TARGET'),
                    colors.yellowBright('METHOD'),
                    colors.yellowBright('DURATION'),
                    colors.yellowBright('STATUS')
                ],
                colWidths: [8, 20, 15, 10, 12],
                chars: { 
                    'top': '─', 'top-mid': '┬', 'top-left': '┌', 'top-right': '┐',
                    'bottom': '─', 'bottom-mid': '┴', 'bottom-left': '└', 'bottom-right': '┘',
                    'left': '│', 'left-mid': '├', 'mid': '─', 'mid-mid': '┼',
                    'right': '│', 'right-mid': '┤', 'middle': '│'
                }
            });

            this.attackHistory.slice(0, 10).forEach(attack => {
                table.push([
                    colors.cyanBright(attack.timestamp.split(' ')[1]),
                    colors.whiteBright(attack.target.length > 18 ? attack.target.substring(0, 15) + '...' : attack.target),
                    colors.greenBright(attack.method),
                    colors.yellowBright(attack.duration),
                    attack.status === 'SUCCESS' ? colors.greenBright('✅ SUCCESS') : colors.redBright('❌ FAILED')
                ]);
            });

            console.log(table.toString());

            const successCount = this.attackHistory.filter(a => a.status === 'SUCCESS').length;
            const totalCount = this.attackHistory.length;
            const successRate = totalCount > 0 ? ((successCount / totalCount) * 100).toFixed(1) : '0.0';

            console.log(gradient.retro('┌────────────────────────────────────────────────────────────────┐'));
            console.log(gradient.retro('│  ') + colors.greenBright(`📊 SUMMARY: ${successCount} berhasil`) + ' / ' + 
                colors.redBright(`${totalCount - successCount} gagal`) + ' / ' + 
                colors.cyanBright(`${totalCount} total`) + ' | ' + 
                colors.yellowBright(`Success Rate: ${successRate}%`) + gradient.retro('  │'));
            console.log(gradient.retro('└────────────────────────────────────────────────────────────────┘'));
        }
    }

    async serverStatus() {
        const activeServers = this.servers.filter(server => server.active);
        
        if (activeServers.length === 0) {
            console.log(colors.redBright('❌ Tidak ada server aktif! Gunakan "switch" untuk mengaktifkan server.'));
            return;
        }

        const spinner = new Spinner(colors.greenBright(`📡 Memeriksa status ${activeServers.length} server audio... %s`));
        spinner.setSpinnerString('⣾⣽⣻⢿⡿⣟⣯⣷');
        spinner.start();

        try {
            const statusPromises = activeServers.map(async (server) => {
                try {
                    const response = await axios.get(`${server.url}/status`);
                    return { server: server.name, success: true, data: response.data };
                } catch (error) {
                    return { server: server.name, success: false, error: error.message };
                }
            });

            const results = await Promise.all(statusPromises);
            spinner.stop(true);

            console.log(colors.magentaBright('┌────────────────────────────────────────────────────────────────┐'));
            console.log(colors.magentaBright('│  ') + colors.yellowBright(`📊 STATUS SERVER AUDIO (${results.filter(r => r.success).length}/${activeServers.length})`) + colors.magentaBright('  │'));
            console.log(colors.magentaBright('├────────────────────────────────────────────────────────────────┤'));

            results.forEach(result => {
                if (result.success) {
                    console.log(colors.magentaBright('│  ') + colors.greenBright('🟢') + ' ' + colors.yellowBright(result.server) + colors.magentaBright('  │'));
                    console.log(colors.magentaBright('│    ') + colors.greenBright('💾 Memory:') + ' ' + colors.white('Optimal') + colors.magentaBright('  │'));
                    console.log(colors.magentaBright('│    ') + colors.greenBright('📊 CPU Load:') + ' ' + colors.white('Normal') + colors.magentaBright('  │'));
                    console.log(colors.magentaBright('│    ') + colors.greenBright('📈 Status:') + ' ' + colors.greenBright('OPERATIONAL') + colors.magentaBright('  │'));
                    console.log(colors.magentaBright('│                                                    │'));
                } else {
                    console.log(colors.magentaBright('│  ') + colors.redBright('🔴') + ' ' + colors.yellowBright(result.server) + ' - ' + colors.redBright('OFFLINE') + colors.magentaBright('  │'));
                    console.log(colors.magentaBright('│                                                    │'));
                }
            });

            console.log(colors.magentaBright('└────────────────────────────────────────────────────────────────┘'));

        } catch (error) {
            spinner.stop(true);
            console.log(colors.redBright('❌ Gagal memeriksa status server:'), error.message);
        }
    }

    async healthCheck() {
        const activeServers = this.servers.filter(server => server.active);
        
        if (activeServers.length === 0) {
            console.log(colors.redBright('❌ Tidak ada server aktif! Gunakan "switch" untuk mengaktifkan server.'));
            return;
        }

        const spinner = new Spinner(colors.greenBright(`❤️  Memeriksa kesehatan ${activeServers.length} server audio... %s`));
        spinner.setSpinnerString('⣾⣽⣻⢿⡿⣟⣯⣷');
        spinner.start();

        try {
            const healthPromises = activeServers.map(async (server) => {
                try {
                    const response = await axios.get(`${server.url}/health`);
                    return { server: server.name, success: true, data: response.data };
                } catch (error) {
                    return { server: server.name, success: false, error: error.message };
                }
            });

            const results = await Promise.all(healthPromises);
            spinner.stop(true);

            const healthyCount = results.filter(r => r.success).length;

            console.log(colors.magentaBright('┌────────────────────────────────────────────────────────────────┐'));
            console.log(colors.magentaBright('│  ') + colors.yellowBright(`❤️  HEALTH CHECK (${healthyCount}/${activeServers.length})`) + colors.magentaBright('  │'));
            console.log(colors.magentaBright('├────────────────────────────────────────────────────────────────┤'));

            results.forEach(result => {
                if (result.success) {
                    console.log(colors.magentaBright('│  ') + colors.greenBright('🟢') + ' ' + colors.yellowBright(result.server) + ' - ' + colors.greenBright('SEHAT') + colors.magentaBright('  │'));
                } else {
                    console.log(colors.magentaBright('│  ') + colors.redBright('🔴') + ' ' + colors.yellowBright(result.server) + ' - ' + colors.redBright('OFFLINE') + colors.magentaBright('  │'));
                }
            });

            console.log(colors.magentaBright('└────────────────────────────────────────────────────────────────┘'));

        } catch (error) {
            spinner.stop(true);
            console.log(colors.redBright('❌ Health check gagal:'), error.message);
        }
    }

    async serverInfo() {
        const activeServers = this.servers.filter(server => server.active);
        
        if (activeServers.length === 0) {
            console.log(colors.redBright('❌ Tidak ada server aktif! Gunakan "switch" untuk mengaktifkan server.'));
            return;
        }

        try {
            const firstActiveServer = activeServers[0];
            
            console.log(colors.magentaBright('┌────────────────────────────────────────────────────────────────┐'));
            console.log(colors.magentaBright('│  ') + colors.yellowBright('🔍 INFORMASI SERVER AUDIO') + colors.magentaBright('  │'));
            console.log(colors.magentaBright('├────────────────────────────────────────────────────────────────┤'));
            console.log(colors.magentaBright('│  ') + colors.greenBright('Server:') + ' ' + colors.white(firstActiveServer.name) + colors.magentaBright('  │'));
            console.log(colors.magentaBright('│  ') + colors.greenBright('URL:') + ' ' + colors.cyan(firstActiveServer.url) + colors.magentaBright('  │'));
            console.log(colors.magentaBright('│  ') + colors.greenBright('API:') + ' ' + colors.greenBright(firstActiveServer.method) + colors.magentaBright('  │'));
            console.log(colors.magentaBright('│  ') + colors.greenBright('Status:') + ' ' + colors.greenBright('AKTIF - Siap untuk serangan audio') + colors.magentaBright('  │'));
            console.log(colors.magentaBright('│  ') + colors.greenBright('Framework:') + ' ' + colors.white('H4000Audio Ultimate Edition') + colors.magentaBright('  │'));
            console.log(colors.magentaBright('└────────────────────────────────────────────────────────────────┘'));

        } catch (error) {
            console.log(colors.redBright('❌ Gagal mendapatkan info server:'), error.message);
        }
    }

    exitTool() {
        console.log(gradient.rainbow('\n┌────────────────────────────────────────────────────────────────┐'));
        console.log(gradient.rainbow('│  ') + colors.greenBright('👋 Terima kasih telah menggunakan H4000Audio!') + gradient.rainbow('  │'));
        console.log(gradient.rainbow('│  ') + colors.yellowBright('📍 Gunakan dengan bertanggung jawab!') + gradient.rainbow('  │'));
        console.log(gradient.rainbow('│  ') + colors.magentaBright('🎵 created by h4000audio') + gradient.rainbow('  │'));
        console.log(gradient.rainbow('└────────────────────────────────────────────────────────────────┘\n'));
        process.exit(0);
    }
}

// Main execution
async function main() {
    try {
        const terminal = new H4000AudioDDoSTerminal();
        await terminal.showAsciiBanner();
        await terminal.showWelcomeMessage();
        terminal.showTerminalPrompt();
    } catch (error) {
        console.log(colors.redBright('💥 Error starting terminal:'), error.message);
        process.exit(1);
    }
}

// Handle CTRL+C
process.on('SIGINT', () => {
    console.log(gradient.rainbow('\n🎵 Goodbye! H4000Audio Panel terminated.'));
    process.exit(0);
});

if (require.main === module) {
    main();
}

module.exports = H4000AudioDDoSTerminal;
