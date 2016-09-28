--Cyber Dragon - Chaos Serpent
function c101020065.initial_effect(c)
	--If this card is Impure Summoned: You can send 1 LIGHT Machine-Type monster from your Deck to the Graveyard.
	local ae3=Effect.CreateEffect(c)
	ae3:SetCategory(CATEGORY_TOGRAVE)
	ae3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae3:SetCode(EVENT_SPSUMMON_SUCCESS)
	ae3:SetCondition(function(e) return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+0x6507 end)
	ae3:SetTarget(c101020065.tgtg)
	ae3:SetOperation(c101020065.tgop)
	c:RegisterEffect(ae3)
	--Once per turn: You can target 1 of your banished LIGHT Machine-Type monsters; shuffle it into your Deck, then add 1 "Overload Fusion" from your Deck to your hand.
	local ae2=Effect.CreateEffect(c)
	ae2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	ae2:SetType(EFFECT_TYPE_IGNITION)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetCountLimit(1)
	ae2:SetTarget(c101020065.tdtg)
	ae2:SetOperation(c101020065.tdop)
	c:RegisterEffect(ae2)
	--If this card attacks an opponent's monster: You can Seal 1 other monster you control, and if you do, this card gains ATK equal to that Sealed monster's ATK until it is Unsealed.
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae3:SetCode(EVENT_ATTACK_ANNOUNCE)
	ae3:SetCondition(function(e) return e:GetHandler():GetBattleTarget()~=nil and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler()) end)
	ae3:SetOperation(c101020065.atkop)
	c:RegisterEffect(ae3)
	if not c101020065.global_check then
		c101020065.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101020065.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101020065.impure=true
c101020065.material=function(mc) return mc:GetLevel()==5 and mc:IsCode(70095154) end
function c101020065.sfilter(c)
	return c:GetFlagEffect(357)==0
end
function c101020065.seal(ec,tc,p)
	local ovg=tc:GetOverlayGroup():Filter(c101020065.sfilter,nil)
	local og=tc:GetOverlayGroup():Filter(c101020065.sfilter,nil)
	ovg:KeepAlive()
	og:KeepAlive()
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(c101020065.sbop(ec,tc:GetPosition(),tc:GetControler(),tc:GetOwner(),ovg))
	e1:SetReset(RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_REMOVE)
	tc:RegisterEffect(e3)
	local ps=tc:GetPosition()
	local cp=tc:GetControler()
	if tc:GetOverlayCount()>0 then Duel.SendtoGrave(tc:GetOverlayGroup(),REASON_RULE) end
	Duel.Overlay(ec,tc)
	local e0=Effect.CreateEffect(ec)
	e0:SetDescription(527)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCountLimit(1)
	e0:SetOperation(c101020065.epops(tc,cp,ps,og))
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,p)
	tc:RegisterFlagEffect(357,RESET_PHASE+PHASE_END,0,1)
	return tc:IsLocation(LOCATION_OVERLAY)
end
function c101020065.sbop(ec,ps,cp,op,ovg)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if bit.band(c:GetReason(),REASON_RULE)==REASON_RULE then
					local e1=Effect.CreateEffect(ec)
					e1:SetDescription(26)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetCountLimit(1)
					e1:SetLabelObject(c)
					e1:SetOperation(c101020065.epop(ps,cp,op,ovg))
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
			end
end
function c101020065.epop(ps,cp,op,ovg)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local g=ovg:Clone()
				ovg:DeleteGroup()
				if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
				local tc=e:GetLabelObject()
				Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
				local tk=Duel.CreateToken(op,tc:GetOriginalCode())
				Duel.MoveToField(tk,tp,cp,LOCATION_MZONE,ps,true)
				local oc=g:GetFirst()
				while oc do
					local p=oc:GetOwner()
					local code=oc:GetOriginalCode()
					Duel.SendtoDeck(oc,nil,-2,REASON_RULE)
					local tk2=Duel.CreateToken(p,code)
					Duel.SendtoHand(tk2,nil,REASON_RULE)
					Duel.Overlay(tk,tk2)
					oc=g:GetNext()
				end
			end
end
function c101020065.epops(tc,p,ps,ovg)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local g=ovg:Clone()
				ovg:DeleteGroup()
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
					if tc:IsLocation(LOCATION_OVERLAY) then
						Duel.MoveToField(tc,tp,p,LOCATION_MZONE,ps,true)
						local oc=g:GetFirst()
						while oc do
							local p=oc:GetOwner()
							local code=oc:GetOriginalCode()
							Duel.SendtoDeck(oc,nil,-2,REASON_RULE)
							local tk=Duel.CreateToken(p,code)
							Duel.SendtoHand(tk,nil,REASON_RULE)
							Duel.Overlay(tc,tk)
							oc=g:GetNext()
						end
					end
				else Duel.SendtoGrave(tc,REASON_RULE) end
			end
end
function c101020065.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,357)
	Duel.CreateToken(1-tp,357)
end
function c101020065.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function c101020065.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020065.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c101020065.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101020065.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101020065.bfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function c101020065.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101020065.bfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020065.bfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101020065.bfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101020065.afilter(c)
	return c:GetCode()==3659803 and c:IsAbleToHand()
end
function c101020065.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local g=Duel.SelectMatchingCard(tp,c101020065.afilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c101020065.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,c)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local atk=tc:GetAttack()
		if c:IsRelateToEffect(e) and c101020065.seal(c,tc,tp) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
