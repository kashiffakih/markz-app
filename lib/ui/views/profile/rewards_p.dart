// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/providers/user_wallet_pr.dart';
// import 'package:aadab/ui/shared/font_sh.dart';

// class RewardsPage extends StatefulWidget {
//   const RewardsPage({Key? key}) : super(key: key);

//   @override
//   State<RewardsPage> createState() => _RewardsPageState();
// }

// class _RewardsPageState extends State<RewardsPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch wallet data asynchronously
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<UserWalletModel>(context, listen: false).getMyUserWallets();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildHeader(),
//               _buildBody(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               size: 18,
//               color: Color(0xFFEED056),
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//           Expanded(
//             child: Text(
//               'Rewards',
//               textAlign: TextAlign.center,
//               style: MyGoogleFontStyle(
//                 fontFamily: 'Urbanist',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF1E232C),
//               ),
//             ),
//           ),
//           const SizedBox(width: 48), // Balance layout
//         ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return Consumer<UserWalletModel>(
//       builder: (context, userWalletModel, child) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               _buildPointsSummary(userWalletModel),
//               const SizedBox(height: 24),
//               _buildRewardsList(userWalletModel),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPointsSummary(UserWalletModel userWalletModel) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(40),
//                 image: const DecorationImage(
//                   fit: BoxFit.cover,
//                   image:
//                       AssetImage('assets/images/gift-removebg-preview-1.png'),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Total Earned Points',
//                   style: MyGoogleFontStyle(
//                     fontFamily: 'Urbanist',
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF303030),
//                   ),
//                 ),
//                 Text(
//                   userWalletModel.totalEarnPoint.toString(),
//                   style: MyGoogleFontStyle(
//                     fontFamily: 'Urbanist',
//                     fontSize: 28,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF000000),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 32),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   Text(
//                     'Total Used Points',
//                     style: MyGoogleFontStyle(
//                       fontFamily: 'Urbanist',
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF303030),
//                     ),
//                   ),
//                   Text(
//                     userWalletModel.totalUsedPoint.toString(),
//                     style: MyGoogleFontStyle(
//                       fontFamily: 'Urbanist',
//                       fontSize: 28,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF000000),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Text(
//                     'Remaining Points',
//                     style: MyGoogleFontStyle(
//                       fontFamily: 'Urbanist',
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF303030),
//                     ),
//                   ),
//                   Text(
//                     userWalletModel.totaRemainingPoint.toString(),
//                     style: MyGoogleFontStyle(
//                       fontFamily: 'Urbanist',
//                       fontSize: 28,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF000000),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRewardsList(UserWalletModel userWalletModel) {
//     if (userWalletModel.userWallets!.isEmpty) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     if (userWalletModel.userWallets == null ||
//         userWalletModel.userWallets!.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Text(
//           'No Rewards Available',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       );
//     }

//     return SizedBox(
//       height: MediaQuery.of(context).size.height - 350,
//       child: ListView.builder(
//         itemCount: userWalletModel.userWallets!.length,
//         scrollDirection: Axis.vertical,
//         itemBuilder: (context, index) {
//           final wallet = userWalletModel.userWallets![index];
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               border: Border.all(color: const Color(0xFFC7B456)),
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color(0x338A959E),
//                   offset: Offset(0, 7),
//                   blurRadius: 19,
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Order Reward ${wallet.source?.split(' ').last ?? ''}',
//                         style: MyGoogleFontStyle(
//                           fontFamily: 'Urbanist',
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF232323),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Order and ${wallet.source ?? ''}',
//                         style: MyGoogleFontStyle(
//                           fontFamily: 'Urbanist',
//                           fontSize: 11,
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xFF909090),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         wallet.getFormattedCreatedAt(),
//                         style: MyGoogleFontStyle(
//                           fontFamily: 'Urbanist',
//                           fontSize: 11,
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xFF909090),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Image.asset(
//                       'assets/images/star-9.png',
//                       width: 7.18,
//                       height: 12.92,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${wallet.amount ?? 0} Points',
//                       style: MyGoogleFontStyle(
//                         fontFamily: 'Urbanist',
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF000000),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/user_wallet_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserWalletModel>(context, listen: false).getMyUserWallets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Color(0xFFEED056),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Rewards',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E232C),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<UserWalletModel>(
      builder: (context, userWalletModel, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildPointsSummary(userWalletModel),
              const SizedBox(height: 24),
              _buildRewardsList(userWalletModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPointsSummary(UserWalletModel userWalletModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      AssetImage('assets/images/gift-removebg-preview-1.png'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Earned Points',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF303030),
                  ),
                ),
                Text(
                  (userWalletModel.totalEarnPoint ?? 0).toString(),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Total Used Points',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF303030),
                    ),
                  ),
                  Text(
                    (userWalletModel.totalUsedPoint ?? 0).toString(),
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Remaining Points',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF303030),
                    ),
                  ),
                  Text(
                    (userWalletModel.totaRemainingPoint ?? 0).toString(),
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardsList(UserWalletModel userWalletModel) {
    if (userWalletModel.userWallets == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final wallets = userWalletModel.userWallets;
    if (wallets == null || wallets.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'No Rewards Available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height - 350,
      child: ListView.builder(
        itemCount: wallets.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          return Container(
            key: ValueKey(wallet.id), // Assuming wallet has an id property
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFC7B456)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x338A959E),
                  offset: Offset(0, 7),
                  blurRadius: 19,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Reward ${wallet.source?.split(' ').last ?? 'Unknown'}',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF232323),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Order and ${wallet.source ?? 'Unknown'}',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF909090),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        wallet.getFormattedCreatedAt(),
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF909090),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/star-9.png',
                      width: 7.18,
                      height: 12.92,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${wallet.amount ?? 0} Points',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
