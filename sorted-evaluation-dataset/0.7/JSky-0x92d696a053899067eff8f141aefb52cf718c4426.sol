// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Julia Sky
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                    //
//                         _ _    _ _      _____             _____ _  ____     __                                                                                                                                     //
//                        | | |  | | |    |_   _|   /\      / ____| |/ /\ \   / /                                                                                                                                     //
//                        | | |  | | |      | |    /  \    | (___ | ' /  \ \_/ /                                                                                                                                      //
//                    _   | | |  | | |      | |   / /\ \    \___ \|  <    \   /                                                                                                                                       //
//                   | |__| | |__| | |____ _| |_ / ____ \   ____) | . \    | |                                                                                                                                        //
//                    \____/ \____/|______|_____/_/    \_\ |_____/|_|\_\   |_|                                                                                                                                        //
//                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                    //
//                                                                                     ,φ                                                                                                                             //
//                                                                                  ,▄▒╬▒╣                                                                                                                            //
//                                                                                .██▓▓▓▓╩                                                                                                                            //
//                                     ;░░░░░░░░░░░░;                            ╓██▓▓╩╙░░                                                                                                                            //
//                                  ;░░░░░░░░░░░░░░░░░│'░░░░░]φ▓▓▄µ░''░░,   ,,░φ▓█▓▓╙░░░░░                                                                                                                            //
//                                ░░░░░░░░░░░$░░░│'  '││.' ░░'╙█████░  '░φ▓░░░φ█▓█░░░░░  ░                                                                                                                            //
//                            ,▄▄██████▀██▄░╠▓▄▄░░░   '    ¡▐▓'╙███╫█▒  '░╠░░║██▒░░░Γ'  ░░                                                                                                                            //
//                         ▄███████████▄∩╙▀██▒║██∩░│'  .░░░░╙▒  └▀██▓▒░░░░╠█▓█╬╬▒░░░  ░░░│                                                                                                                            //
//                       ,██████████████▌▒▄░╙╙▀╩*∩'  ░░│░░░░░║    ╙█╩░░░░░║███╠▒░░░░░░░░░'                                                                                                                            //
//                      ╔█████████████████▒▒░░ ''░░░'││ '''''    │'░░░░░░φ║██████▒░░░░░│░╓                                                                                                                            //
//                    ╓███████▓█████████████▒░░▐▓█░░░░░          │░░░░░░░╠╣█████▀░│░░░░▄██                                                                                                                            //
//                 .φ▓██▓▓▓█▓████████████████▓░⌠▓▓▒╠φ▒"░░░     │'░░░░░░░φ║██████∩░░░░▄█╬▓█                                                                                                                            //
//                ░║██████▓███████████████████ε ║█▒░▒▓█▄▒░░   │░░░░░░▒φ╠║▓██████▄░░▄█╣▓███                                                                                                                            //
//             ;░░φ███████████████████▓███████▌░║██░░╬██╬░░░░░░░░░░▒▒╬╠╣▓██╬█████████▓████                                                                                                                            //
//           ░░░░φ╣████████████████████████████▒░╣█▌░░░╚▒░░░░░░φφ╠╬╬╬╣╣▓███▓█████████████╙                                                                                                                            //
//          ¡░░░░╠██████████████████████████████░░╚██░╠╬░░░░░▒╠╠╠╬╣▓▓█████████████████▀┌░░                                                                                                                            //
//            │'░║███████████████████████╬██████▒░░░╠▀▒▒░░φ▒╠╬╣╣▓▓█████████████████▀░░φ░░░                                                                                                                            //
//            "░φ║██████████████████████▓████████╬▓▒╬╠╬╬╬╬╬╣▓██████░╠█████████████╬▒░φ▒▒▒░                                                                                                                            //
//               ╙█████████████████████▓████████████▓▓▓▓█████████╠╬▒█████████████╬╬╬▒╠╬░░░                                                                                                                            //
//               ⌠█████████████████████████████████████████████╙╚║███████║▌████████╬╬╬░░░░                                                                                                                            //
//                ║█████████████████████████████████████████▓╣████████████████████~╙╣▓▒░░░                                                                                                                            //
//                ╚██████████████████████████████████████████████████████║████████░  ╙▓▒░░                                                                                                                            //
//                 ║████████████████████████████████████████████████████████████▒░    ^╫▒▒                                                                                                                            //
//                 ^╫██████████████████▓█████████████████████▒▒░║████████████████▒░     ╙╣                                                                                                                            //
//                  ╙████████████████████████████████████████╩░╠╚╠█▀▀╙╙╙╙╙╚╚╙╙╙╙╙╙░≥,                                                                                                                                 //
//                   ╙██████████████████████████████████████▌░φ▒φ╠██▓░║░░░░░░░░░░░░░░│░░≥,                                                                                                                            //
//                    ╙▓████████████████████████████████████▌░░░░φ▓██▓███▒░░░░φ░░░░░░░░░░░                                                                                                                            //
//                     ;║████████████████████████████████████╠░░φ▓██╬╩░╚║▒░░▒╚░░░░││░░░░░░                                                                                                                            //
//                  ]██████▀█████████████████████████████████▒░░║█▒╠Γ╚╚Σ░░φ░░░░░││││'│''││                                                                                                                            //
//                  ╫████░φφφ▓████████████████████████████████▒░╩╚╫▒░▒▒╩╚░░░░░░░░░░░░░.│                                                                                                                              //
//                  ╚██████████████████████████████████████████▄░░░▒░░▒░░░░░░░φ▄▄▄█▄▄▄▄░░░                                                                                                                            //
//                   ╙▀█████▓█████████████████████████████████████████████▓███████████████                                                                                                                            //
//                     ¡║████████████████████████████████████████████████████████████▓████                                                                                                                            //
//                     ▐████▒╠▓███████████████████████████████████████████████████████████                                                                                                                            //
//                ,,,╓╓φ╣████████████████████████████████████████████████████████████████▓                                                                                                                            //
//           ╓███████████████████████████████████████████████████████████████████████████▓                                                                                                                            //
//         ]▓█████▀▀█████████████████████████████████████████████████████████████████████▒                                                                                                                            //
//        ¡║▓██╩░░φ▄▄▄███████████████████████████████████████████████████████████████████╩                                                                                                                            //
//         ╙╚██▒╠╣▓██████████████████████████████████████████████████████████████████▀░░░Γ                                                                                                                            //
//           ╙╙╣▓████████████████████████╬╠█████████████████████████████████╬╙▀▀▀╙╙""'                                                                                                                                //
//            .φ████▀▀╙╙▀███████████████╩╙╙╙▀╣▓██████████████████████████████▄                                                                                                                                        //
//                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract JSky is ERC721Creator {
    constructor() ERC721Creator("Julia Sky", "JSky") {}
}