# Domestic LLM Inference Benchmark Summary

> Date: 2026-05-11  
> Context: The vendor team needs to benchmark two LLM inference scenarios on domestic AI servers, then provide reproducible test data, recommended configurations, and a basis for the customer’s own online validation.

---

## 1. Project Positioning

This project is not simply about building an inference platform or running a demo. It is closer to a **domestic LLM inference solution selection and benchmark validation project**.

The main objective is to help the customer establish a reliable performance baseline for large model inference on domestic AI servers.

Key goals include:

- Identify the inference capability boundary of domestic servers under different workloads.
- Compare throughput, SLA performance, and stability across models, deployment modes, and resource configurations.
- Produce reproducible benchmark methods and data.
- Provide recommended configurations for the customer’s later online validation and procurement evaluation.

The vendor’s value is not to make the final decision for the customer, but to provide trustworthy, comparable, and reproducible benchmark evidence.

---

## 2. Role Definition

Current role relationship:

- Wang Lei / vendor team: responsible for benchmark design, execution, data collection, and recommendation output.
- Teacher Liang / customer side: responsible for providing real workload inputs, scenario requirements, and evaluation criteria.
- Customer objective: use vendor benchmark data for internal evaluation, online validation, and final solution selection.

The vendor team should act as a joint validation team rather than only a demo provider.

---

## 3. Two Core Scenarios

The current project can be divided into two major scenarios:

1. Multimodal data generation / multimodal inference.
2. Agent / OpenClaw-style online interaction.

Both scenarios require domestic AI servers, but their optimization goals and benchmark metrics are very different.

---

## 4. Scenario 1: Multimodal Data Generation / Inference

### 4.1 Scenario Definition

Scenario 1 focuses on data generation and multimodal inference.

Typical workload characteristics:

- Input may include text, images, and videos.
- Multi-turn context may exist.
- Input plus output should be aligned to less than 64k tokens.
- Extreme cases may be close to 32k input plus 32k output.
- Output may be long.
- Single-task latency can be relatively long.
- The key objective is throughput, not low request latency.

### 4.2 Candidate Models

Current understanding:

- Kimi 2.6
- Qwen3.5-397B

These models are better suited for multimodal data generation because they are expected to support native multimodal input and long-context generation.

### 4.3 Optimization Target

This scenario is not highly sensitive to online SLA.

TTFT and TPOT can be relaxed. Long single-request duration, queuing, and asynchronous task execution may be acceptable.

The real priorities are:

- How many samples can be generated per hour or per day.
- How many tokens can be generated per minute or per hour.
- Whether GPU/NPU utilization is high enough.
- Whether long-context and long-output workloads are stable.
- Whether the cost per token is acceptable.

### 4.4 Key Metrics

Recommended primary metrics:

| Metric | Description |
|---|---|
| TPM | Tokens per minute, core throughput metric |
| Samples per hour | Business-level data generation capacity |
| GPU/NPU utilization | Whether hardware is efficiently used |
| HBM / memory usage | Long-context and KV cache pressure |
| Batch scalability | Ability to improve throughput with larger batches |
| Long-output stability | Whether 16k/32k output remains stable |
| OOM rate | Stability under extreme context length |
| Success rate | Production usability |
| Cost per million tokens | ROI and resource planning reference |

TTFT and TPOT should still be recorded, but they are not the first-priority optimization goals for this scenario.

### 4.5 Required Customer Inputs

To make the benchmark match the real production workload, the customer should provide a dataset or workload profile.

Required information:

- Input token distribution: AVG / P50 / P95 / P99.
- Output token distribution: AVG / P50 / P95 / P99.
- Ratio of text, image, and video inputs.
- Image count and typical image specification.
- Video duration, resolution, FPS, and frame sampling strategy.
- Average number of turns for multi-turn context.
- Total task volume, such as daily generation target.
- Completion window, such as 8 hours or 24 hours.
- Whether queuing is allowed.
- Whether asynchronous return is allowed.
- Whether retry is allowed after failure.
- Whether output quality requires secondary validation.

### 4.6 Suggested Test Design

Recommended test cases:

| Case | Input | Output | Purpose |
|---|---|---|---|
| S | 4k | 4k | Basic capability test |
| M | 16k | 8k / 16k | Medium long-context test |
| L | 32k | 32k | Extreme long-context and long-output test |
| MM-Image | Image + text | Long text | Multimodal image-text generation test |
| MM-Video | Video + text | Long text | Video understanding and data generation test |

During testing, the vendor team should observe:

- Throughput curve under different batch sizes.
- Whether TPOT degrades during long output.
- Whether KV cache fragmentation or scheduling jitter occurs.
- Whether memory capacity becomes the bottleneck.
- Whether prefill/decode disaggregation is required.
- Throughput improvement before and after PD disaggregation.

---

## 5. Scenario 2: Agent / OpenClaw-Style Online Interaction

### 5.1 Scenario Definition

Scenario 2 is a typical online Agent interaction workload.

Typical workload characteristics:

- User waits for the model response online.
- Fast first-token response matters.
- Multi-turn conversations may exist.
- Tool calling, MCP, API calls, or workflow orchestration may be involved.
- User experience is sensitive to waiting time.
- P50 / P95 / P99 latency should be tracked.

This scenario should not optimize only for maximum throughput. It should balance online experience and concurrency capacity.

### 5.2 Candidate Models

Current understanding:

- GLM5.1
- DSV4

These models do not need to handle image or video input in this scenario. They are mainly used for Agent dialogue, tool use, reasoning, and workflow orchestration.

### 5.3 Optimization Target

The key objectives are:

- Fast TTFT.
- Smooth streaming output.
- Stable P95 / P99 latency under concurrency.
- Stable multi-turn context handling.
- Controlled end-to-end tool calling latency.
- Significant performance gain when cache hit rate is high.

### 5.4 Key Metrics

Recommended primary metrics:

| Metric | Description |
|---|---|
| TTFT P50 / P95 / P99 | First-token user experience |
| TPOT P50 / P95 / P99 | Streaming smoothness |
| P95 total response time | End-user waiting experience |
| Concurrency capacity | Online request capacity |
| Queue delay | Whether queuing becomes the bottleneck |
| Cache hit rate | Context reuse benefit |
| Tool calling latency | Agent toolchain overhead |
| Success rate | Agent task stability |
| TPS / TPM | Auxiliary throughput metric |
| GPU/NPU utilization | Hardware efficiency |

### 5.5 Required Customer Inputs

The customer should provide clear SLA targets and workload assumptions.

Required information:

- TTFT target, such as <= 3s or <= 5s.
- TPOT target, such as <= 50ms or <= 100ms.
- P95 total response time target.
- Peak concurrent requests.
- Number of concurrent online users.
- Average number of dialogue turns per task.
- Average input and output tokens per turn.
- Tool calling ratio.
- Average number of tool calls per task.
- Whether streaming output is required.
- Expected cache hit rate.
- Whether system prompt and tool schema are fixed.
- Whether long-context reuse exists.

### 5.6 Suggested Test Design

Recommended test cases:

| Case | Description | Purpose |
|---|---|---|
| Single-turn chat | No tool calling | Measure baseline TTFT / TPOT |
| Multi-turn chat | 5-10 turns | Measure performance under KV cache growth |
| Single-tool call | One tool per turn | Measure toolchain overhead |
| Multi-tool call | Multiple tools and workflow orchestration | Measure Agent runtime overhead |
| Cache disabled | No context cache | Establish baseline |
| 50% cache hit | Partial reuse | Measure cache benefit |
| 80% cache hit | High reuse | Measure best-case cache benefit |
| Concurrency ramp-up | 10 / 50 / 100 / 200 concurrent requests | Identify collapse point |

The test should not only cover single-turn chat. It should cover multi-turn context, tool calling, and P95/P99 behavior under concurrency.

---

## 6. Core Difference Between the Two Scenarios

| Dimension | Scenario 1: Multimodal Data Generation | Scenario 2: Agent Interaction |
|---|---|---|
| Business pattern | Offline / near-offline generation | Online interaction |
| Candidate models | Kimi2.6 / Qwen3.5-397B | GLM5.1 / DSV4 |
| Multimodal input | Required | Not required |
| SLA sensitivity | Low | High |
| Core metrics | TPM, samples/hour, utilization, cost | TTFT, TPOT, P95 latency, concurrency |
| Queuing | Acceptable | Should be controlled |
| Asynchronous execution | Acceptable | Usually not suitable for main interaction path |
| Output length | Can be very long | Usually medium, depending on task |
| Cache value | High, improves throughput | Very high, improves experience |
| PD disaggregation value | High | Depends on context length and concurrency |
| Test focus | Throughput limit and stability | Online SLA and concurrency boundary |

---

## 7. Interpretation of Wang Lei’s Metric Questions

Wang Lei mentioned the following metrics:

- Business dataset input and output length: AVG / P50 / P99.
- TTFT.
- TPOT.
- Concurrency requirement.
- Cache hit rate.

These metrics should be interpreted by scenario.

| Metric | Scenario 1 | Scenario 2 |
|---|---|---|
| Input length AVG/P50/P99 | Required for throughput and memory planning | Required for SLA and context pressure evaluation |
| Output length AVG/P50/P99 | Very important, determines decode duration | Important, affects user waiting time |
| TTFT | Record only, not primary target | Core SLA metric |
| TPOT | Record and observe long-output degradation | Core user experience metric |
| Concurrency | More like batch task parallelism | Core online capacity metric |
| Cache hit rate | Improves throughput and reduces prefill cost | Improves TTFT and multi-turn experience |

---

## 8. Benchmark Methodology

To make the benchmark credible to the customer, the test methodology should be unified.

### 8.1 Unified Test Inputs

Do not rely only on demo prompts. The benchmark should use real or representative customer workload samples.

For Scenario 1, the dataset should include:

- Text-only input.
- Image + text input.
- Video + text input.
- Multi-turn context.
- Different input and output length buckets.

For Scenario 2, the dataset should include:

- Single-turn Q&A.
- Multi-turn Q&A.
- Tool calling.
- Long system prompt.
- Different cache hit rate settings.

### 8.2 Unified Metric Schema

Recommended fields:

```text
model
server_type
deployment_mode
tp_size
pp_size
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
throughput_tps
throughput_tpm
samples_per_hour
gpu_or_npu_util
hbm_util
kv_cache_usage
cache_hit_rate
success_rate
oom_count
error_count
cost_per_million_tokens
```

### 8.3 Unified Test Duration

Do not rely only on short peak tests.

Recommended durations:

- Smoke test: 5-10 minutes for quick validation.
- Standard pressure test: 30 minutes for stable throughput observation.
- Long-run stability test: 1 hour or longer to observe degradation, memory fragmentation, and scheduling jitter.

### 8.4 Unified Traffic Model

Recommended traffic modes:

- Fixed concurrency.
- Step-by-step concurrency ramp-up.
- Burst traffic.
- Production-like arrival pattern.

---

## 9. Domestic AI Server Test Focus

Because both scenarios require domestic AI servers, the benchmark should focus on practical bottlenecks.

Key points:

- Whether the large model can be loaded and run stably.
- Multi-card parallel efficiency.
- HBM / memory capacity boundary.
- KV cache pressure under long context.
- Whether 32k output causes performance degradation.
- Whether the visual encoder becomes a bottleneck in multimodal workloads.
- Whether PD disaggregation brings stable improvement.
- Whether TTFT collapses quickly under high concurrency.
- Whether tool calling impacts end-to-end SLA.
- Whether long-run tests expose degradation, errors, OOM, or scheduling jitter.

The value of the benchmark is not only to prove that the model can run, but to identify where it runs best, where the boundary is, and what risks remain.

---

## 10. Recommended Deliverables

### 10.1 Test Plan Document

Should include:

- Background.
- Scenario definition.
- Model scope.
- Hardware scope.
- Metrics.
- Test methodology.
- Dataset description.
- Test environment description.

### 10.2 Benchmark Data Tables

Should include:

- Scenario 1 multimodal data generation throughput results.
- Scenario 2 Agent SLA and concurrency results.
- Horizontal comparison across domestic servers.
- Comparison across deployment modes.
- Before/after comparison for PD disaggregation.
- Cache hit rate comparison.

### 10.3 Recommended Solutions

For each scenario, provide:

- Recommended model.
- Recommended domestic server configuration.
- Recommended deployment mode.
- Recommended concurrency or batch settings.
- Recommended cache strategy.
- Whether PD disaggregation is recommended.
- Expected throughput or SLA.
- Key risks and applicability boundary.

### 10.4 Customer Online Validation Guide

Should include:

- How to reproduce vendor benchmark results.
- What metrics to collect during online validation.
- Which benchmark results can be directly referenced.
- Which results need recalibration with real production traffic.

---

## 11. Current Status and Next Step

Current status:

- Scenario split is clear.
- Scenario 1 is multimodal data generation / inference, with throughput as the priority.
- Scenario 2 is Agent / OpenClaw-style interaction, with online SLA as the priority.
- Both scenarios require domestic AI servers.
- The vendor team is waiting for critical customer inputs.

Pending customer inputs:

1. Scenario 1 real dataset or workload distribution.
2. Scenario 2 Agent SLA and concurrency requirements.

Once these inputs are provided, formal benchmark execution can begin.

---

## 12. One-Sentence Summary

This project should follow a **workload-driven + SLA-driven** benchmark approach:

- Scenario 1 uses the real multimodal dataset to measure maximum data generation throughput on domestic AI servers.
- Scenario 2 uses clear Agent SLA targets to measure the online interaction capability boundary of domestic AI servers.
- The final output should be a reproducible, comparable, and customer-verifiable domestic LLM inference capability baseline.
