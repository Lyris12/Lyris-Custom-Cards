--created & coded by Lyris
--Black Ring Connection
function c101010170.initial_effect(c)
	--Tribute as many face-up monsters as possible that are listed on a Fusion Monster that can only be Special Summoned with a "Black Ring" Spell Card, then Special Summon that Fusion Monster from your Extra Deck. If the Summoned monster attacks an opponent's monster while this card is banished, your opponent cannot activate Spell/Trap cards until the end of the Damage Step. After activation, banish this card instead of sending it to the Graveyard.
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010170.target)
	e1:SetOperation(c101010170.activate)
	c:RegisterEffect(e1)
end
function c101010170.spfilter(c,e,tp)
	local loc=LOCATION_MZONE
	if c:IsRace(RACE_MACHINE) then loc=loc+LOCATION_REMOVED end
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x5d) and c.material(tp,loc,0,0)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101010170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010170.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010170.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c101010170.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local loc=LOCATION_MZONE
		if tc:IsRace(RACE_MACHINE) then loc=loc+LOCATION_REMOVED end
		local mat=tc.material(tp,loc,0,1)
		local fg=mat:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		Duel.Release(fg,REASON_EFFECT)
		local rg=mat:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RETURN)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetCondition(c101010170.atkcon)
		e1:SetOperation(c101010170.atkop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
	if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function c101010170.atkcon(e)
	return (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil) and Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandler():GetControler(),LOCATION_REMOVED,0,1,nil,101010170)
end
function c101010170.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010170.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c101010170.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
