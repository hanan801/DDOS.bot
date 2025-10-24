const GEMINI_API_KEY = 'AIzaSyBXCuOfj-ivUcq0ZFYW4do5bAmPuGFKaZo';

const { execSync } = require('child_process');
const requiredModules = [
    'axios', 'chalk', 'readline', 'figlet', 'gradient-string', 'cli-spinner', 'cli-table3', 'fs', 'https', 'open', 'node-fetch'
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

// Colors
const colors = {
    reset: '\x1b[0m',
    red: (text) => `\x1b[31m${text}\x1b[0m`,
    green: (text) => `\x1b[32m${text}\x1b[0m`,
    yellow: (text) => `\x1b[33m${text}\x1b[0m`,
    blue: (text) => `\x1b[34m${text}\x1b[0m`,
    magenta: (text) => `\x1b[35m${text}\x1b[0m`,
    cyan: (text) => `\x1b[36m${text}\x1b[0m`,
    white: (text) => `\x1b[37m${text}\x1b[0m`,
    greenBright: (text) => `\x1b[92m${text}\x1b[0m`,
    yellowBright: (text) => `\x1b[93m${text}\x1b[0m`,
    cyanBright: (text) => `\x1b[96m${text}\x1b[0m`,
};

class H4000AudioDDoSTerminal {
    constructor() {
        this.baseUrl = 'http://localhost:3000';
        this.servers = [
            { 
                name: '🟢 MAIN SERVER', 
                url: 'http://localhost:3000',
                status: 'online',
                method: '/attack',
                active: true
            }
        ];
        this.attackHistory = [];
        this.methodsList = [];
        this.username = 'h4000audio';
        this.hostname = 'audio-panel';
        this.currentDir = '~/servers';
    }

    async showAsciiBanner() {
        return new Promise((resolve) => {
            const banner = [
                gradient.rainbow('╔════════════════════════════════════════════════════════════════╗'),
                gradient.rainbow('║') + gradient.retro('  _    _ 4000     _       _                  _         ') + gradient.rainbow('║'),
                gradient.rainbow('║') + gradient.retro(' | |  | |        | |     | |                (_)        ') + gradient.rainbow('║'),
                gradient.rainbow('║') + gradient.retro(' | |__| |  _  _  | |__   | | __  ___   _ __  _   ___   ') + gradient.rainbow('║'),
                gradient.rainbow('║') + gradient.retro(' |  __  | | | | | |  _ \\  | |/ / / _ \\ |  __|| | / _ \\  ') + gradient.rainbow('║'),
                gradient.rainbow('║') + gradient.retro(' | |  | | | |_| | | |_) | |   < | (_) || |   | || (_) | ') + gradient.rainbow('║'),
                gradient.rainbow('║') + gradient.retro(' |_|  |_|  \\__,_| |_.__/  |_|\\_\\ \\___/ |_|   |_| \\___/  ') + gradient.rainbow('║'),
                gradient.rainbow('║                                                              ║'),
                gradient.rainbow('║') + gradient.passion('           🎵 H4000Audio DDoS Framework v2.2.2 🎵') + gradient.rainbow('           ║'),
                gradient.rainbow('║') + gradient.cristal('              [ VIP Edition 2025 ]') + gradient.rainbow('                     ║'),
                gradient.rainbow('╚════════════════════════════════════════════════════════════════╝'),
                '',
                gradient.retro('     🌐 System   : ') + colors.white('Premium Layer 7'),
                gradient.retro('     🛡️ Security : ') + colors.greenBright('Protected'),
                gradient.retro('     👤 License  : ') + colors.yellowBright('VIP'),
                gradient.retro('     ⚡ Status   : ') + colors.greenBright('READY'),
                gradient.retro('     👨‍💻 Creator  : ') + colors.magentaBright('h4000audio'),
                ''
            ].join('\n');
            console.log(banner);
            resolve();
        });
    }

    async showWelcomeMessage() {
        const welcome = [
            gradient.retro('╔════════════════════════════════════════════════════════════════╗'),
            gradient.retro('║') + gradient.rainbow('   Selamat datang di H4000Audio Premium DDoS Control Panel! ') + gradient.retro('║'),
            gradient.retro('║') + gradient.cristal('   Tools Layer 7 VIP, UI modern, fitur lengkap!         ') + gradient.retro('║'),
            gradient.retro('║') + gradient.passion('             create by h4000audio                    ') + gradient.retro('║'),
            gradient.retro('╚════════════════════════════════════════════════════════════════╝'),
            ''
        ].join('\n');
        console.log(welcome);
        await new Promise(resolve => setTimeout(resolve, 1000));
    }

    showTerminalPrompt() {
        const prompt = `\n${colors.cyan('╭─[')}${colors.magentaBright(`${this.username}@${this.hostname}`)}${colors.cyan(']─[')}${colors.yellow(`${this.currentDir}`)}${colors.cyan(']')}
${colors.cyan('╰─❯')} ${colors.magentaBright('›')} `;
        
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

            case 'attack':
            case 'ddos':
                await this.launchAttack(args);
                break;

            case 'methods':
            case 'list':
                await this.showMethods();
                break;

            case 'servers':
                await this.listServers();
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

            case 'ai':
                await this.aiExplainTool();
                break;

            case 'info':
                await this.showInfo();
                break;

            case '':
                break;

            default:
                console.log(colors.redBright(`❌ Command not found: ${cmd}`));
                console.log(colors.yellowBright('💡 Type "help" for available commands'));
                break;
        }

        this.showTerminalPrompt();
    }

    async showHelp() {
        const helpBanner = [
            gradient.rainbow('╔════════════════════════════════════════════════════════╗'),
            gradient.rainbow('║   ') + gradient.retro('DAFTAR PERINTAH UTAMA - H4000AUDIO PANEL') + gradient.rainbow('   ║'),
            gradient.rainbow('╚════════════════════════════════════════════════════════╝'),
            ''
        ].join('\n');

        const helpTable = new Table({
            head: [colors.yellowBright('COMMAND'), colors.yellowBright('DESCRIPTION')],
            colWidths: [15, 45],
            chars: { 'top': '═', 'top-mid': '╦', 'top-left': '╔', 'top-right': '╗', 'bottom': '═', 'bottom-mid': '╩', 'bottom-left': '╚', 'bottom-right': '╝', 'left': '║', 'left-mid': '╠', 'mid': '═', 'mid-mid': '╬', 'right': '║', 'right-mid': '╣', 'middle': '║' }
        });

        helpTable.push(
            [colors.greenBright('attack'), colors.white('Start a new DDoS attack')],
            [colors.greenBright('methods'), colors.white('List available attack methods')],
            [colors.greenBright('servers'), colors.white('List configured servers')],
            [colors.greenBright('ai'), colors.white('Get AI explanation')],
            [colors.greenBright('info'), colors.white('Show system info')],
            [colors.greenBright('clear'), colors.white('Clear terminal')],
            [colors.greenBright('help'), colors.white('Show this help')],
            [colors.greenBright('exit'), colors.white('Exit the terminal')]
        );

        console.log(helpBanner);
        console.log(helpTable.toString());
        console.log(gradient.rainbow('\nExample: ') + colors.yellowBright('attack https://example.com 60 bass'));
        console.log(gradient.passion('╔══════════════════════════════════════════════════════════╗'));
        console.log(gradient.passion('║           create by h4000audio - VIP Edition           ║'));
        console.log(gradient.passion('╚══════════════════════════════════════════════════════════╝'));
    }

    async showMethods() {
        this.methodsList = [
            { name: 'bass', description: 'Bass Boost Attack', power: '★★★☆☆', icon: '🔊' },
            { name: 'treble', description: 'High Frequency Attack', power: '★★★★☆', icon: '🔊' },
            { name: 'subwoofer', description: 'Deep Bass Method', power: '★★★★★', icon: '🔈' },
            { name: 'equalizer', description: 'Multi-band Attack', power: '★★★☆☆', icon: '🎛️' },
            { name: 'amplifier', description: 'Power Amplifier Flood', power: '★★★★☆', icon: '📻' }
        ];

        const title = [
            gradient.rainbow('╔══════════════════════════════════════════════════════════╗'),
            gradient.rainbow('║   🎵  H4000AUDIO ATTACK METHODS - VIP EDITION 2025  🎵  ║'),
            gradient.rainbow('╚══════════════════════════════════════════════════════════╝'),
            ''
        ].join('\n');
        console.log(title);

        const table = new Table({
            head: [colors.yellowBright('METHOD'), colors.yellowBright('DESCRIPTION'), colors.yellowBright('POWER'), colors.yellowBright('ICON')],
            colWidths: [15, 35, 10, 8],
            chars: { 'top': '═', 'top-mid': '╦', 'top-left': '╔', 'top-right': '╗', 'bottom': '═', 'bottom-mid': '╩', 'bottom-left': '╚', 'bottom-right': '╝', 'left': '║', 'left-mid': '╠', 'mid': '═', 'mid-mid': '╬', 'right': '║', 'right-mid': '╣', 'middle': '║' }
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
        console.log(gradient.passion('╔══════════════════════════════════════════════════════════╗'));
        console.log(gradient.passion('║        Type "attack <url> <time> <method>" to start!    ║'));
        console.log(gradient.passion('╚══════════════════════════════════════════════════════════╝'));
    }

    async launchAttack(args) {
        if (args.length < 3) {
            console.log(colors.redBright('❌ Usage: attack <url> <time> <method>'));
            console.log(colors.yellowBright('💡 Example: attack https://example.com 60 bass'));
            console.log(colors.greenBright('🔍 Run "methods" to see available methods'));
            return;
        }

        const [target, time, method] = args;
        
        const spinner = new Spinner(colors.greenBright(`🎵 Launching ${method} attack on ${target}... %s`));
        spinner.setSpinnerString('⣾⣽⣻⢿⡿⣟⣯⣷');
        spinner.start();

        try {
            await new Promise(resolve => setTimeout(resolve, 2000));
            spinner.stop(true);

            const attackBanner = [
                gradient.rainbow('╔══════════════════════════════════════════════════════════╗'),
                gradient.rainbow('║') + ' '.repeat(10) + colors.yellowBright('🎵 ATTACK LAUNCHED SUCCESSFULLY! 🎵') + ' '.repeat(18) + gradient.rainbow('║'),
                gradient.rainbow('╚══════════════════════════════════════════════════════════╝'),
                ''
            ].join('\n');
            console.log(attackBanner);

            const table = new Table({
                head: [colors.yellowBright('TARGET'), colors.yellowBright('TIME'), colors.yellowBright('METHOD'), colors.yellowBright('STATUS')],
                colWidths: [25, 8, 15, 12],
                chars: { 'top': '═', 'top-mid': '╦', 'top-left': '╔', 'top-right': '╗', 'bottom': '═', 'bottom-mid': '╩', 'bottom-left': '╚', 'bottom-right': '╝', 'left': '║', 'left-mid': '╠', 'mid': '═', 'mid-mid': '╬', 'right': '║', 'right-mid': '╣', 'middle': '║' }
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
            console.log(colors.redBright('❌ Attack failed:'), error.message);
        }
    }

    async listServers() {
        console.log(colors.magentaBright('╔══════════════════════════════════════════════════════════╗'));
        console.log(colors.magentaBright('║') + ' ' + colors.yellowBright('🌐 CONFIGURED SERVERS') + '                           ' + colors.magentaBright('║'));
        console.log(colors.magentaBright('╠══════════════════════════════════════════════════════════╣'));
        
        this.servers.forEach((server, index) => {
            console.log(colors.magentaBright('║') + ' ' + colors.cyan(`${index + 1}.`) + ' ' + colors.white(server.name) + ' '.repeat(25) + colors.magentaBright('║'));
            console.log(colors.magentaBright('║') + '   ' + colors.yellowBright('URL:') + ' ' + colors.cyan(server.url) + ' '.repeat(30) + colors.magentaBright('║'));
            console.log(colors.magentaBright('║') + '   ' + colors.yellowBright('Status:') + ' ' + colors.greenBright('ONLINE') + ' '.repeat(25) + colors.magentaBright('║'));
            console.log(colors.magentaBright('║') + ' '.repeat(60) + colors.magentaBright('║'));
        });
        
        console.log(colors.magentaBright('╚══════════════════════════════════════════════════════════╝'));
    }

    async aiExplainTool() {
        const prompt = `Jelaskan secara singkat tentang tools DDoS Layer 7 dengan nama H4000Audio Premium DDoS Framework. Fitur: manajemen server, berbagai metode serangan, monitoring real-time, dan interface premium. Jelaskan untuk user awam.`;
        
        try {
            const response = await axios.post(
                `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GEMINI_API_KEY}`,
                { contents: [{ parts: [{ text: prompt }] }] },
                { headers: { 'Content-Type': 'application/json' } }
            );
            
            const aiText = response.data.candidates?.[0]?.content?.parts?.[0]?.text || 'Tidak ada response dari AI.';
            
            console.log(gradient.retro('\n╔════════════════════════════════════════════════════════╗'));
            console.log(gradient.retro('║           🤖 PENJELASAN AI - H4000AUDIO             ║'));
            console.log(gradient.retro('╚════════════════════════════════════════════════════════╝'));
            console.log(colors.cyanBright(aiText));
            
        } catch (e) {
            console.log(colors.redBright('❌ Gagal mengambil penjelasan dari AI!'));
        }
    }

    async showInfo() {
        console.log(colors.magentaBright('╔══════════════════════════════════════════════════════════╗'));
        console.log(colors.magentaBright('║') + ' ' + colors.yellowBright('🔍 SYSTEM INFORMATION - H4000AUDIO') + '               ' + colors.magentaBright('║'));
        console.log(colors.magentaBright('╠══════════════════════════════════════════════════════════╣'));
        console.log(colors.magentaBright('║') + ' ' + colors.greenBright('🎵 Nama:') + ' H4000Audio Premium DDoS Framework'.repeat(15) + colors.magentaBright('║'));
        console.log(colors.magentaBright('║') + ' ' + colors.greenBright('📦 Versi:') + ' 2.2.2 VIP Edition'.repeat(25) + colors.magentaBright('║'));
        console.log(colors.magentaBright('║') + ' ' + colors.greenBright('👨‍💻 Creator:') + ' h4000audio'.repeat(30) + colors.magentaBright('║'));
        console.log(colors.magentaBright('║') + ' ' + colors.greenBright('🏗️  Type:') + ' Layer 7 DDoS Panel'.repeat(25) + colors.magentaBright('║'));
        console.log(colors.magentaBright('║') + ' ' + colors.greenBright('📊 Methods:') + ` ${this.methodsList.length} audio methods`.repeat(15) + colors.magentaBright('║'));
        console.log(colors.magentaBright('║') + ' ' + colors.greenBright('🌐 Servers:') + ` ${this.servers.length} configured`.repeat(22) + colors.magentaBright('║'));
        console.log(colors.magentaBright('╚══════════════════════════════════════════════════════════╝'));
    }

    exitTool() {
        console.log(gradient.rainbow('\n╔══════════════════════════════════════════════════════════╗'));
        console.log(gradient.rainbow('║') + ' ' + colors.greenBright('👋 Terima kasih telah menggunakan H4000Audio!') + '     ' + gradient.rainbow('║'));
        console.log(gradient.rainbow('║') + ' ' + colors.yellowBright('📍 Gunakan dengan bertanggung jawab!') + '               ' + gradient.rainbow('║'));
        console.log(gradient.rainbow('║') + ' ' + colors.magentaBright('🎵 create by h4000audio') + '                              ' + gradient.rainbow('║'));
        console.log(gradient.rainbow('╚══════════════════════════════════════════════════════════╝\n'));
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
