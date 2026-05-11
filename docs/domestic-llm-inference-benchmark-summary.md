# Domestic LLM Serving Benchmark Summary

> Date: 2026-05-11  
> Context: The customer has two representative LLM serving scenarios that must be evaluated on domestic accelerator servers. The vendor team is expected to provide a reproducible benchmark methodology, measured results, deployment recommendations, and a clear basis for the customer’s own online validation.

---

## 1. Project Scope

This work is not simply about standing up an inference endpoint or running a proof-of-concept demo. It should be treated as a **domestic LLM serving benchmark and solution validation project**.

The goal is to help the customer establish a practical performance baseline for large-model serving on domestic accelerator servers.

The benchmark should answer the following questions:

- What is the serving capacity boundary of each domestic server configuration under real customer workloads?
- How do different models, deployment topologies, batching strategies, cache strategies, and prefill/decode layouts compare?
- Which configuration is best suited for throughput-oriented multimodal generation?
- Which configuration is best suited for latency-sensitive agent interaction?
- What results can the customer reproduce later in its own online environment?

The vendor’s role is not to make the final decision on behalf of the customer. The real value is to provide benchmark evidence that is measurable, comparable, and reproducible.

---

## 2. Stakeholders and Responsibilities

The current working relationship can be summarized as follows:

- Wang Lei / vendor team: responsible for benchmark design, test execution, metric collection, result analysis, and recommendation.
- Teacher Liang / customer side: responsible for confirming business scenarios, providing representative datasets or service-level requirements, and evaluating the results.
- Customer objective: use the benchmark results as input for internal assessment, online validation, and final solution selection.

In this phase, the vendor team is effectively acting as a joint validation partner rather than a pure demo or implementation provider.

---

## 3. Two Benchmark Scenarios

The project should be split into two independent benchmark tracks:

1. Multimodal data generation / multimodal inference.
2. Agent-style online interaction, similar to an OpenClaw-style agent runtime.

Both tracks must run on domestic accelerator servers, but their optimization goals and success metrics are very different. They should not be judged using one single metric set.

---

## 4. Scenario 1: Multimodal Data Generation / Inference

### 4.1 Scenario Definition

Scenario 1 is a throughput-oriented multimodal generation workload.

Typical workload characteristics:

- Inputs may include text, images, and videos.
- Multi-turn context may be present.
- The total input + output length should be aligned to less than 64k tokens.
- Extreme cases may approach 32k input tokens plus 32k generated tokens.
- Outputs can be long.
- Per-request latency can be relatively relaxed.
- The primary objective is generation throughput, not interactive latency.

This scenario should be viewed as an offline or near-offline generation pipeline. It should not be optimized using the same criteria as an interactive chat service.

### 4.2 Candidate Models

Based on the current understanding, the candidate models for this scenario are:

- Kimi 2.6
- Qwen3.5-397B

These models are more suitable for this track because they are expected to support native multimodal inputs and long-context generation, which are central to the data-generation workload.

### 4.3 Optimization Objective

This scenario is not highly sensitive to interactive service-level objectives.

Time to first token (TTFT) and time per output token (TPOT, often reported as inter-token latency) can be relaxed. Long-running requests, queuing, and asynchronous execution may all be acceptable.

The benchmark should primarily optimize for:

- Samples generated per hour or per day.
- Tokens generated per minute or per hour.
- Accelerator utilization under sustained load.
- Stability under long-context and long-output workloads.
- Cost per generated token.
- Throughput gains from batching, prefix/KV-cache reuse, and prefill/decode disaggregation.

### 4.4 Key Metrics

Recommended primary metrics:

| Metric | Description |
|---|---|
| Output tokens per minute | Core generation throughput metric |
| Samples per hour | Business-facing generation capacity |
| Accelerator utilization | Whether GPU/NPU resources are effectively used |
| Device memory / HBM usage | Pressure from long context and KV cache |
| Batch scalability | Whether larger batches continue to improve throughput |
| Long-output stability | Whether 16k/32k-token generation remains stable |
| OOM rate | Failure rate under long-context or high-batch conditions |
| Success rate | Production-readiness indicator |
| Cost per million generated tokens | ROI and capacity-planning reference |

TTFT and TPOT should still be collected, but they should not be treated as the primary optimization targets for this track.

### 4.5 Customer Inputs Required

To make the benchmark meaningful, the customer should provide either a real dataset or a representative workload profile.

Required inputs include:

- Input token length distribution: average / P50 / P95 / P99.
- Output token length distribution: average / P50 / P95 / P99.
- Ratio of text-only, image-text, and video-text requests.
- Typical number of images per request and image specifications.
- Video duration, resolution, frame rate, and frame-sampling strategy.
- Average number of dialogue turns, if multi-turn context is involved.
- Required data generation volume per batch or per day.
- Completion window, such as within 8 hours or within 24 hours.
- Whether request queuing is allowed.
- Whether asynchronous job completion is acceptable.
- Whether failed jobs can be retried.
- Whether generated outputs require downstream quality review.

Without these inputs, a synthetic prompt-only benchmark may not reflect the customer’s real production behavior.

### 4.6 Suggested Test Design

Recommended test cases:

| Case | Input | Output | Purpose |
|---|---|---|---|
| S | 4k tokens | 4k tokens | Basic serving capability |
| M | 16k tokens | 8k / 16k tokens | Medium long-context workload |
| L | 32k tokens | 32k tokens | Extreme long-context and long-output workload |
| MM-Image | Image + text | Long text | Image-text generation workload |
| MM-Video | Video + text | Long text | Video understanding and generation workload |

During testing, the team should monitor:

- Throughput curves under different batch sizes.
- Whether TPOT / inter-token latency degrades during long generation.
- Whether KV-cache fragmentation or scheduler jitter appears over time.
- Whether device memory / HBM becomes the limiting factor.
- Whether the vision encoder becomes the bottleneck for multimodal inputs.
- Whether prefill/decode disaggregation is required.
- Throughput improvement before and after prefill/decode disaggregation.

---

## 5. Scenario 2: Agent-Style Online Interaction

### 5.1 Scenario Definition

Scenario 2 is a latency-sensitive interactive agent workload. It is similar to an OpenClaw-style agent runtime in which the user submits a task, the agent reasons over the request, may call external tools, orchestrates a workflow, and then returns a result.

Typical workload characteristics:

- The user waits online for the model response.
- Fast first-token latency directly affects user experience.
- Multi-turn dialogue may be involved.
- Tool calling, MCP servers, API calls, or workflow orchestration may be part of the request path.
- P50 / P95 / P99 latency must be tracked under concurrency.
- The goal is to balance responsiveness, concurrency, and cost, not simply maximize offline throughput.

### 5.2 Candidate Models

Based on the current understanding, the candidate models for this scenario are:

- GLM5.1
- DSV4

These models do not need to process image or video input in this track. They are mainly used for agent dialogue, reasoning, tool use, and workflow orchestration.

### 5.3 Optimization Objective

The key objective is to provide a stable online interaction experience.

The benchmark should focus on:

- Low TTFT so the user sees the first token quickly.
- Stable TPOT / inter-token latency so streaming output feels smooth.
- Controlled P95 / P99 latency under concurrency.
- Stable behavior as multi-turn context grows.
- End-to-end latency of tool-calling workflows.
- Performance improvement from prompt/prefix cache hits.

### 5.4 Key Metrics

Recommended primary metrics:

| Metric | Description |
|---|---|
| TTFT P50 / P95 / P99 | First-token latency and perceived responsiveness |
| TPOT / inter-token latency P50 / P95 / P99 | Streaming smoothness |
| P95 end-to-end response time | User-facing request latency |
| Concurrent request capacity | Online serving capacity |
| Queueing delay | Whether admission control or scheduler backlog is the bottleneck |
| Prompt / prefix cache hit rate | Benefit from reusable context |
| Tool-calling latency | Overhead introduced by agent tools and workflow steps |
| Task success rate | Stability of the agent workflow |
| Tokens per second / tokens per minute | Auxiliary throughput metrics |
| Accelerator utilization | Resource efficiency under online load |

### 5.5 Customer Inputs Required

For this track, vague requirements such as “good user experience” are not enough. The customer needs to define measurable service-level objectives.

Required inputs include:

- TTFT target, for example <= 3s or <= 5s.
- TPOT / inter-token latency target, for example <= 50ms or <= 100ms.
- P95 end-to-end response time target.
- Peak concurrent request target.
- Expected number of active users or sessions.
- Average number of turns per agent task.
- Average input tokens and output tokens per turn.
- Percentage of requests involving tool calls.
- Average number of tool calls per task.
- Whether streaming output is required.
- Expected prompt/prefix cache hit rate.
- Whether the system prompt and tool schemas are mostly static.
- Whether long-context reuse exists across turns or sessions.

These inputs determine how the test should be designed and whether a measured result is acceptable.

### 5.6 Suggested Test Design

Recommended test cases:

| Case | Description | Purpose |
|---|---|---|
| Single-turn chat | No tool calling | Establish baseline TTFT / TPOT |
| Multi-turn chat | 5-10 turns | Observe performance as context grows |
| Single-tool workflow | One tool call per task | Measure toolchain overhead |
| Multi-tool workflow | Multiple tools and orchestration steps | Measure agent runtime overhead |
| Cache disabled | No prompt/prefix cache | Establish no-cache baseline |
| 50% cache hit rate | Partial context reuse | Measure cache benefit |
| 80% cache hit rate | High context reuse | Measure best-case cache benefit |
| Concurrency ramp-up | 10 / 50 / 100 / 200 concurrent requests | Identify capacity boundary and collapse point |

The agent benchmark should not stop at single-turn chat. The most useful results come from multi-turn context, tool-calling workflows, cache behavior, and P95/P99 latency under concurrency.

---

## 6. Key Differences Between the Two Tracks

| Dimension | Scenario 1: Multimodal Generation | Scenario 2: Agent Interaction |
|---|---|---|
| Workload pattern | Offline / near-offline generation | Online interactive serving |
| Candidate models | Kimi2.6 / Qwen3.5-397B | GLM5.1 / DSV4 |
| Multimodal input | Required | Not required |
| Latency sensitivity | Low | High |
| Primary metrics | Output TPM, samples/hour, utilization, cost | TTFT, TPOT, P95 latency, concurrency |
| Queuing | Acceptable | Must be controlled |
| Asynchronous execution | Acceptable | Usually not suitable for the main interaction path |
| Output length | Can be very long | Usually moderate, depending on the task |
| Cache value | High, mainly improves throughput | Very high, directly improves responsiveness |
| Prefill/decode disaggregation value | High | Depends on context length and concurrency pressure |
| Test focus | Throughput ceiling and long-run stability | SLO compliance and concurrency boundary |

---

## 7. How to Interpret Wang Lei’s Metric Questions

Wang Lei asked for the following information:

- Input and output length distribution: average, P50, P99.
- TTFT.
- TPOT.
- Concurrency requirements.
- Cache hit rate.

These are all important, but their priority differs by scenario.

| Metric | Scenario 1 | Scenario 2 |
|---|---|---|
| Input length average/P50/P99 | Used for throughput and memory planning | Used for SLO and context-pressure analysis |
| Output length average/P50/P99 | Critical because it determines decode occupancy | Important because it affects user waiting time |
| TTFT | Collect for reference, not the main target | Core service-level metric |
| TPOT / inter-token latency | Collect and watch for long-output degradation | Core streaming-experience metric |
| Concurrency | More like batch job parallelism | Core online serving capacity metric |
| Cache hit rate | Reduces prefill cost and improves throughput | Improves TTFT, multi-turn experience, and end-to-end latency |

---

## 8. Benchmark Methodology

A credible benchmark requires a consistent methodology. Otherwise, results from different models or servers will not be comparable.

### 8.1 Standardized Test Inputs

The benchmark should not rely on hand-written demo prompts only. It should use customer-provided data or representative workload samples.

For Scenario 1, the dataset should cover:

- Text-only requests.
- Image-text requests.
- Video-text requests.
- Multi-turn context.
- Multiple input/output length buckets.

For Scenario 2, the dataset should cover:

- Single-turn Q&A.
- Multi-turn dialogue.
- Tool-calling tasks.
- Long system prompts.
- Different prompt/prefix cache hit rates.

### 8.2 Standardized Metric Schema

Recommended metric fields:

```text
model
server_type
accelerator_type
deployment_mode
tensor_parallel_size
pipeline_parallel_size
batch_size
concurrency
input_tokens_avg
input_tokens_p50
input_tokens_p95
input_tokens_p99
output_tokens_avg
output_tokens_p50
output_tokens_p95
output_tokens_p99
ttft_avg
ttft_p50
ttft_p95
ttft_p99
tpot_avg
tpot_p50
tpot_p95
tpot_p99
inter_token_latency_avg
throughput_tokens_per_second
throughput_tokens_per_minute
samples_per_hour
accelerator_utilization
hbm_utilization
kv_cache_usage
prompt_cache_hit_rate
success_rate
oom_count
error_count
cost_per_million_output_tokens
```

### 8.3 Standardized Test Duration

Short peak tests are not sufficient.

Recommended test durations:

- Smoke test: 5-10 minutes to validate environment and serving path.
- Standard load test: 30 minutes to observe sustained throughput and latency.
- Long-run stability test: 1 hour or longer to observe throughput degradation, memory fragmentation, scheduler jitter, and error rate.

### 8.4 Standardized Traffic Model

Recommended traffic patterns:

- Fixed concurrency.
- Step-wise concurrency ramp-up.
- Burst traffic.
- Production-like arrival pattern.

Results from different traffic models should be reported separately. They should not be mixed into one comparison table.

---

## 9. Focus Areas for Domestic Accelerator Servers

Because both tracks must run on domestic accelerator servers, the benchmark should pay special attention to practical serving bottlenecks.

Key focus areas:

- Whether the model can be loaded and served reliably.
- Multi-accelerator parallel efficiency.
- Device memory / HBM capacity boundary.
- KV-cache pressure under long context.
- Whether 32k-token generation causes throughput degradation.
- Whether the vision encoder becomes the bottleneck in multimodal workloads.
- Whether prefill/decode disaggregation provides stable gains.
- Whether TTFT degrades sharply under high concurrency.
- Whether tool calls significantly increase end-to-end latency.
- Whether long-run tests reveal slowdown, OOM, runtime errors, or scheduler instability.

The benchmark should prove more than “the model can run.” It should identify:

- Which workload the server handles best.
- Where the capacity boundary is.
- Which metric breaks first.
- Which optimization actually helps.
- Which risks the customer should validate again online.

---

## 10. Recommended Deliverables

### 10.1 Benchmark Plan

The plan should include:

- Project background.
- Scenario definitions.
- Model scope.
- Hardware / accelerator scope.
- Metric definitions.
- Test methodology.
- Dataset description.
- Test environment description.

### 10.2 Benchmark Result Tables

The result tables should include:

- Scenario 1 multimodal generation throughput results.
- Scenario 2 agent latency and concurrency results.
- Cross-server comparison across domestic accelerator servers.
- Comparison across deployment modes.
- Before/after comparison for prefill/decode disaggregation.
- Prompt/prefix cache hit-rate comparison.

### 10.3 Recommended Serving Configurations

For each scenario, the recommendation should include:

- Recommended model.
- Recommended domestic server configuration.
- Recommended deployment topology.
- Recommended batch or concurrency settings.
- Recommended cache strategy.
- Whether prefill/decode disaggregation is recommended.
- Expected throughput or service-level performance.
- Key risks and applicability boundaries.

### 10.4 Customer Online Validation Guide

The guide should explain:

- How to reproduce the vendor benchmark.
- Which metrics to collect during customer-side online validation.
- Which benchmark results can be directly referenced.
- Which results must be recalibrated using real production traffic.

---

## 11. Current Status and Next Steps

Current status:

- The two benchmark tracks have been clearly separated.
- Scenario 1 is multimodal generation / inference, with throughput as the priority.
- Scenario 2 is agent-style online interaction, with service-level objectives as the priority.
- Both tracks must be evaluated on domestic accelerator servers.
- The vendor team is waiting for critical customer inputs.

Pending customer inputs:

1. Real dataset or workload distribution for Scenario 1.
2. Agent SLOs, concurrency targets, and tool-calling assumptions for Scenario 2.

Once these inputs are available, formal benchmark execution can begin.

---

## 12. One-Sentence Summary

This project should follow a **workload-driven and SLO-driven** benchmark approach:

- Scenario 1 uses real multimodal workloads to measure the maximum generation throughput and long-run stability of domestic accelerator servers.
- Scenario 2 uses explicit agent SLOs to measure responsiveness, concurrency capacity, and end-to-end workflow latency.
- The final output should be a reproducible, comparable, and customer-verifiable baseline for domestic LLM serving capability.
