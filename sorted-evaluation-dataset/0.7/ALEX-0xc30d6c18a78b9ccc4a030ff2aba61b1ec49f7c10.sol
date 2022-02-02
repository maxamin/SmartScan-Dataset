// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Alexandre Laprise
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//                                                                                          //
//                   _    _                                                                 //
//                    ▐█▀█ _                                                                //
//                   _╙█_╙█                                                       _   __    //
//                     ╙█ ╟▌                                            _____ ,▄▄▄▄æª▀⌐_    //
//                   __ ╟█╫▌,,╓▄╓__            _ __               _ _ _,▄▄██▀▀╙└`_____      //
//             __▄▄██▀▀▀╙╙█▌└└└└└¬_    __ ,▄▄▄▄▄▄▄▄,_       __   ,▄▄█▀▀╙└_                  //
//           ▄█▀▀└`_  __▄▀└╙█▄_  __,▄▄█▀▀╙└─  ___ `╙█▄___ __╓▄██▀╙└_____                    //
//          ╟█▄__  __▄█▀└    ╙▀▄▄█▀╙─  __           _└▀▀█▀▀▀╙¬_                             //
//           '╙╙█████▄,  _    _ ╙█___                                                       //
//           '╙╙╙` _'╙╙╙▀▀▀██████▀                                                          //
//                                                                                          //
//         ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀                //
//                                                                                          //
//          ▄▀█ █░░ █▀▀ ▀▄▀ ▄▀█ █▄░█ █▀▄ █▀█ █▀▀   █░░ ▄▀█ █▀█ █▀█ █ █▀ █▀▀                 //
//          █▀█ █▄▄ ██▄ █░█ █▀█ █░▀█ █▄▀ █▀▄ ██▄   █▄▄ █▀█ █▀▀ █▀▄ █ ▄█ ██▄                 //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract ALEX is ERC721Creator {
    constructor() ERC721Creator("Alexandre Laprise", "ALEX") {}
}