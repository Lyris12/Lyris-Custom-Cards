--created by NovaTsukimori
--coded by Lyris
--Rank-Up-Magic Lyris Force
function c101020121.initial_effect(c)
	--Target 1 Xyz Monster you control; Special Summon from your Extra Deck, 1 "Blitzkrieg" Xyz Monster with the same Type as that monster but 1 Rank higher by using that target as the Xyz Material. (This Special Summon is treated as an Xyz Summon. Xyz Materials attached to it also become Xyz Materials on the Summoned monster.)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101020121.target)
	e1:SetOperation(c101020121.activate)
	c:RegisterEffect(e1)
	--If a monster that was Summoned by this card's effect is destroyed and sent to the Graveyard: You can add this card from your Graveyard to your hand. You can only use this effect of "Rank-Up-Magic Lyris Force" once per Duel.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+101020121)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,101020121+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c101020121.thtg)
	e2:SetOperation(c101020121.thop)
	c:RegisterEffect(e2)
end
function c101020121.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetRank()>0
		and Duel.IsExistingMatchingCard(c101020121.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank(),c:GetRace())
end
function c101020121.filter2(c,e,tp,mc,rk,rc)
	return c:GetRank()==rk+1 and c:GetRace()==rc and c:IsSetCard(0x167)
		and mc:IsCanBeXyzMaterial(c) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c101020121.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101020121.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)
		and Duel.IsExistingTarget(c101020121.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101020121.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101020121.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c101020121.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank(),tc:GetRace())
	local sc=sg:GetFirst()
	if sc then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.Overlay(sc,og)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetOperation(c101020121.check)
		e1:SetReset(RESET_EVENT+0x17a0000)
		sc:RegisterEffect(e1)
	end
end
function c101020121.check(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsReason(REASON_DESTROY) then
		Duel.RaiseSingleEvent(e:GetOwner(),EVENT_CUSTOM+101020121,e,r,rp,tp,0)
	end
end
function c101020121.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c101020121.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
