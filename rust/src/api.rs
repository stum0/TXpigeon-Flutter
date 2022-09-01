use anyhow::Result;

use std::process;

use tokio::runtime::Runtime;

use log::{error, LevelFilter};
//use log::Level;
//use android_logger::{Config};
use env_logger::{Builder, WriteStyle};

use bitcoin::{consensus::deserialize, hashes::hex::FromHex, Network, Transaction};

use crate::peers::PeerManager;

pub fn platform(tx: String) -> Result<()> {
    
    // android_logger::init_once(
    //     Config::default().with_min_level(Level::Trace));

    let mut builder = Builder::new();

    builder
        .filter(None, LevelFilter::Trace)
        .write_style(WriteStyle::Always)
        .init();
    

    //let tx:String = "02000000000101535227bfe2c25b3f72bb388c7190b354d7157f679ff07b423db3c18eb52ec3a90000000000ffffffff01d8ca020000000000160014966542367595fc0108b6133efce1fe629c2770f4024730440220313595b56ae15d5d290c9995d6c2b3242963a4fbfb633d9d2dacc4047e84d484022038a225b6fff2808db9a3ff82eb7e6f32d4e08add55772347a32156b505c5f8e601210259abe18711052eea2e1de8a5ecc57805deb2fee828dba543c6b294d8691b718600000000".to_string();
    let network = Network::Testnet;
    let txhex: Transaction = deserialize(&Vec::from_hex(&tx)?).unwrap_or_else(|_error| {
        error!("transaction format incorrect, must be a raw bitcoin transaction");
        process::exit(1);
    });

    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        let peer_manager = PeerManager::new(10, txhex, network).await;

        let t2 = tokio::spawn(peer_manager.clone().broadcast_tx());
        let t1 = tokio::spawn(peer_manager.maintain_peers());

        t1.await.unwrap();
        t2.await.unwrap();
    });

    Ok(())
}
