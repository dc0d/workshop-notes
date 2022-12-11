pub mod handlers;
pub mod router;
pub mod zoo;

use async_trait::async_trait;
use std::{net::SocketAddr, sync::Arc};

use model::action_boundaries::{ActionInput, ActionOutput, Error, TheAction};
use zoo::{ReqCtx, Settings};

#[tokio::main]
async fn main() {
    let req_ctx: Arc<ReqCtx> = Arc::new(ReqCtx {
        action: Arc::new(SomeTheActionImplementation),
        settings: Settings::default(),
    });
    let router = router::app_router(req_ctx);

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    axum::Server::bind(&addr)
        .serve(router.into_make_service())
        .await
        .unwrap();
}

struct SomeTheActionImplementation;

#[async_trait]
impl TheAction for SomeTheActionImplementation {
    async fn serve_resolved(&self, _input: ActionInput) -> Result<ActionOutput, Error> {
        let result: ActionOutput = Default::default();
        Ok(result)
    }
}
