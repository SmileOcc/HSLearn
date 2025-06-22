import { emitter } from "@kit.BasicServicesKit";

export class NetworkEventData implements emitter.InnerEvent {
  eventId: number;
  priority?: emitter.EventPriority | undefined;

  constructor(eventId: number) {
    this.eventId = eventId;
  }

}